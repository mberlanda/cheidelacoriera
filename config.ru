# frozen_string_literal: true

# --- Start of unicorn worker killer code ---

if ENV['RAILS_ENV'] == 'production'
  require 'unicorn/worker_killer'

  max_request_min = Integer(ENV.fetch('UNICORN_MAX_REQUESTS_MIN') { 500 })
  max_request_max = Integer(ENV.fetch('UNICORN_MAX_REQUESTS_MAX') { 600 })

  # Max requests per worker
  use Unicorn::WorkerKiller::MaxRequests, max_request_min, max_request_max

  oom_min = Integer(ENV.fetch('UNICORN_OOM_MB_MIN') { 240 }) * (1024**2)
  oom_max = Integer(ENV.fetch('UNICORN_OOM_MB_MAX') { 260 }) * (1024**2)

  # Max memory size (RSS) per worker
  use Unicorn::WorkerKiller::Oom, oom_min, oom_max
end

# --- End of unicorn worker killer code ---

# This file is used by Rack-based servers to start the application.
require_relative 'config/environment'

run Rails.application
