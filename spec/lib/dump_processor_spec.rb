# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DumpProcessor do
  def dump_path(file_name)
    File.join(File.dirname(__FILE__), 'dump_processor', file_name)
  end

  context 'when 0 records' do
    it 'generates 0 lines output' do
      input_path = dump_path('0-records-input.txt')
      output_path = dump_path('0-records-output.txt')

      described_class.new(input_path, output_path).process

      output_count = `wc -l #{output_path}`.split.first.to_i
      expect(output_count).to eq(0)
    end
  end

  context 'when 1 record from two tables' do
    xit 'generates 2 lines output' do
      input_path = dump_path('1-record-input.txt')
      output_path = dump_path('1-record-output.txt')

      described_class.new(input_path, output_path).process

      output_count = `wc -l #{output_path}`.split.first.to_i
      expect(output_count).to eq(2)
    end
  end

  context 'when 500 records from one table and 1 from another' do
    xit 'generates 3 lines output' do
      input_path = dump_path('500-records-input.txt')
      output_path = dump_path('500-records-output.txt')

      described_class.new(input_path, output_path).process

      output_count = `wc -l #{output_path}`.split.first.to_i
      expect(output_count).to eq(3)
    end
  end
end
