# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Chei de la Coriera <cheidelacoriera@gmail.com>',
          reply_to: 'cheidelacoriera@gmail.com'

  layout 'mailer'
end
