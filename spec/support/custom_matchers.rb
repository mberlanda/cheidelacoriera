# frozen_string_literal: true

require 'rspec/expectations'
require 'nokogiri'

RSpec::Matchers.define :be_a_valid_html do
  match do |actual|
    Nokogiri::XML.parse(actual).errors.empty?
  end
  failure_message do |actual|
    "expected that #{actual} would be a valid html"
  end
end
