class CreateQuizUserGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :quiz_user_groups do |t|
      t.references :quiz, null: false, foreign_key: true
      t.references :user_group, null: false, foreign_key: true
      t.timestamps
    end

    add_index :quiz_user_groups, [:quiz_id, :user_group_id], unique: true
  end
end
