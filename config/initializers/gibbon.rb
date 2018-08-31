# frozen_string_literal: true

Gibbon::Request.api_key = ENV['mailchimp_api_key']
Gibbon::Request.timeout = 15
Gibbon::Request.open_timeout = 15
Gibbon::Request.symbolize_keys = true
Gibbon::Request.debug = false

module Mailchimp
  extend self

  def list_id
    @list_id ||= ENV['mailchimp_list_id']
  end

  def calculate_id(email)
    Digest::MD5.hexdigest(email)
  end
end
