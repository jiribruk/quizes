# frozen_string_literal: true

# ApplicationMailer is the base mailer for the application.
#
# @see https://guides.rubyonrails.org/action_mailer_basics.html
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
