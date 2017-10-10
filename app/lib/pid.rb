# frozen_string_literal: true

class Pid
  class << self
    def create_for_task(logger, action)
      pid = Pid.new(action)
      begin
        pid.create
      rescue StandardError => e
        logger.error(e.message)
        raise e
      end
      logger.info("Started to retrieve #{action} with PID #{pid.current}")
      pid
    end
  end

  def initialize(action)
    @action = action
  end

  # rubocop:disable Metrics/LineLength
  def create
    raise StandardError, "Process #{current} already running" if File.exist?(file_path)
    File.write(file_path, $PROCESS_ID)
  end
  # rubocop:enable Metrics/LineLength

  def current
    File.read(file_path)
  end

  def file_path
    Rails.root.join("#{@action}.pid")
  end

  def delete
    File.delete(file_path)
  end
end
