# frozen_string_literal: true

Gibbon::Request.api_key = ENV.fetch('mailchimp_api_key', nil)
Gibbon::Request.timeout = 15
Gibbon::Request.open_timeout = 15
Gibbon::Request.symbolize_keys = true
Gibbon::Request.debug = false

module Mailchimp
  extend self

  def list_id
    @list_id ||= ENV.fetch('mailchimp_list_id', nil)
  end

  def calculate_id(email)
    Digest::MD5.hexdigest(email)
  end
end
