# frozen_string_literal: true

# UserGroupsController handles CRUD operations for user groups.
# Only the owner of a group can manage it (create, edit, update, destroy).
# Groups can be used to share private quizzes with selected users.
#
# @see https://guides.rubyonrails.org/action_controller_overview.html
class UserGroupsController < ApplicationController
  before_action :user_group, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user_group_ownership, only: [:edit, :update, :destroy]

  # GET /user_groups
  # Displays all user groups owned by current user
  #
  # @return [void]
  def index
    @user_groups = current_user.owned_user_groups.includes(:users)
  end

  # GET /user_groups/:id
  # Shows details of a specific user group
  #
  # @return [void]
  def show
    @members = user_group.users
    @quizzes = user_group.quizzes.includes(:user)
  end

  # GET /user_groups/new
  # Displays form for creating a new user group
  #
  # @return [void]
  def new
    @user_group = current_user.owned_user_groups.build
  end

  # POST /user_groups
  # Creates a new user group
  #
  # @return [void]
  def create
    @user_group = current_user.owned_user_groups.build(user_group_params)
    if @user_group.save
      flash[:notice] = t('flash.messages.success')
      redirect_to user_group_path(@user_group)
    else
      flash[:alert] = @user_group.errors.full_messages.join(', ')
      render :new, status: :unprocessable_content
    end
  end

  # GET /user_groups/:id/edit
  # Displays form for editing an existing user group
  #
  # @return [void]
  def edit
  end

  # PATCH/PUT /user_groups/:id
  # Updates an existing user group
  #
  # @return [void]
  def update
    if user_group.update(user_group_params)
      flash[:notice] = t('flash.messages.success')
      redirect_to user_group_path(user_group)
    else
      flash[:alert] = user_group.errors.full_messages.join(', ')
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /user_groups/:id
  # Deletes a user group and all its memberships
  #
  # @return [void]
  def destroy
    user_group.destroy
    flash[:notice] = t('user_groups.messages.deleted')
    redirect_to user_groups_path
  end

  private

  # Retrieves user group by ID and caches it
  #
  # @return [UserGroup] the user group instance
  def user_group
    @user_group ||= UserGroup.find(params[:id])
  end

  # Authorizes that current user owns the user group
  #
  # @return [void]
  def authorize_user_group_ownership
    unless user_group.owner == current_user
      flash[:alert] = t('user_groups.errors.ownership_required')
      redirect_to user_groups_path
    end
  end

  # Strong parameters for user group
  #
  # @return [ActionController::Parameters] permitted parameters
  def user_group_params
    params.require(:user_group).permit(:name, :description)
  end
end
