# frozen_string_literal: true

app_dir = File.expand_path('..', __dir__)
shared_dir = "#{app_dir}/shared"
rails_env = ENV.fetch('RAILS_ENV') { 'development' }

worker_processes 5
timeout 30
preload_app true

if rails_env == 'production'
  listen "#{shared_dir}/sockets/unicorn.sock", backlog: 64
  # Set master PID location
  pid "#{shared_dir}/pids/unicorn.pid"
else
  listen ENV.fetch('PORT') { 3000 }, backlog: 64, tcp_nopush: true
end

# Garbage collection settings.
GC.respond_to?(:copy_on_write_friendly=) &&
  GC.copy_on_write_friendly = true

before_fork do |_server, _worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |_server, _worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.establish_connection
end
