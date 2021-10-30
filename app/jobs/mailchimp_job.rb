# frozen_string_literal: true

class MailchimpJob < ApplicationJob
  queue_as :default

  def perform(*users_to_add)
    gibbon = Gibbon::Request.new
    users_to_add.each do |u|
      gibbon.lists(Mailchimp.list_id).members(calculate_id(u)).upsert(
        **format_user_body(u)
      )
      u.update(mailing_listed: true)
    rescue Gibbon::MailChimpError => e
      Rails.logger.warn(e)
    end
  end

  private

  def calculate_id(u)
    Mailchimp.calculate_id(u.email)
  end

  def format_user_body(u)
    {
      body: {
        email_address: u.email,
        status: 'subscribed',
        merge_fields: { FNAME: u.first_name || '', LNAME: u.last_name || '' }
      }
    }
  end
end
