# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: 'cheidelacoriera@gmail.com'

  def activation_email(user)
    @user = user
    # attachments.inline['logo.png'] = File.read(
    #   Rails.root.join('public', 'images', 'cheidelacoriera_logo.png')
    # )
    mail(to: @user.email, subject: 'Conferma Attivazione | Chei De La Coriera')
    @user.update(activation_date: Date.today)
  end
end
