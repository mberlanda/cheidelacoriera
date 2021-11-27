# frozen_string_literal: true

require 'rails_helper'

class FakeIo
  attr_reader :content

  def initialize
    @content = []
  end

  def write(log)
    @content << log
  end

  def close; end
end

RSpec.describe MultiIo do
  context 'when no io is passed' do
    it 'does not raise any error' do
      multi_io = described_class.new
      multi_io.write('foo')
      multi_io.close
    end
  end

  context 'when any io is passed' do
    it 'forwards the logs to every target' do
      fake_io_a = FakeIo.new
      fake_io_b = FakeIo.new
      multi_io = described_class.new(fake_io_a, fake_io_b)
      multi_io.write('foo')
      multi_io.close

      expect(fake_io_a.content).to match_array(%w[foo])
      expect(fake_io_b.content).to match_array(%w[foo])
    end
  end
end
