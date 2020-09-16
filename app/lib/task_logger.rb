# frozen_string_literal: true

module TaskLogger
  extend self

  def init_logger
    @init_logger ||= Logger.new(multi_io_logger)
  end

  def multi_io_logger
    MultiIo.new(STDOUT, File.open(task_logger_path, 'a'))
  end

  def task_logger_path
    Rails.root.join('log', 'tasks.log')
  end
end
