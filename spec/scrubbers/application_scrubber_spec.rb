# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationScrubber do
  it 'loads in memory without errors' do
    node = double('Node')
    allow(node).to receive(:text?).and_return(true)

    scrubber = ApplicationScrubber.new
    scrubber.skip_node? node
  end
end
