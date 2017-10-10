# frozen_string_literal: true

class DumpProcessor
  def initialize(input_path, output_path)
    @input_file = input_path
    @output_file = output_path
    @hash = {}
  end

  def insert_regex
    /^INSERT INTO (\b\w*\b) \(([\w,\s]+)\) VALUES \((.+)\);$/
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def process
    File.readlines(@input_file).each do |line|
      matched = line.match(insert_regex)
      next unless matched
      table_name, columns, data = matched.captures
      @prev_table_name ||= table_name
      if @prev_table_name != table_name
        write_data(@prev_table_name)
        @prev_table_name = table_name
      end
      @hash[table_name] ||= {}
      @hash[table_name][:columns] ||= "(#{columns})"
      @hash[table_name][:data] ||= []
      @hash[table_name][:data] << "(#{data})"
      write_data(table_name) if @hash[table_name][:data].size > 499
    end
    write_data(@hash.keys.first)
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def write_data(table_name)
    write_to_file(
      build_insert_statement(
        table_name, @hash[table_name][:columns], @hash[table_name][:data]
      ), @output_file
    )
    @hash.delete(table_name)
  end

  def build_insert_statement(table_name, columns, data)
    "INSERT INTO #{table_name} #{columns} VALUES #{data.join(', ')}"\
    " ON CONFLICT DO NOTHING;\n"
  end

  def write_to_file(line, my_file)
    File.open(my_file, 'a') { |f| f.write(line) }
  end
end
