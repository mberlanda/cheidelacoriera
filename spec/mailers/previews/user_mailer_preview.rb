# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def activation_email
    user = User.first
    UserMailer.activation_email(user)
  end

  def rejection_email
    user = User.first
    UserMailer.rejection_email(user)
  end
end
