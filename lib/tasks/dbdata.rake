# frozen_string_literal: true

desc 'DB Data manipulation'
namespace :dbdata do
  def task_logger
    @task_logger ||= TaskLogger.init_logger
  end

  def dumpfile(db_env)
    Rails.root.join('tmp', "#{db_env}-dump.sql")
  end

  def bulkfile(db_env)
    Rails.root.join('tmp', "#{db_env}-bulk.sql")
  end

  desc 'Pull heroku db to development'
  task from_heroku: :environment do
    Rake::Task['dbdata:dump'].invoke(:heroku)
    Rake::Task['dbdata:restore'].invoke(:heroku, :development)
  end

  desc 'Dump source db data'
  task :dump, [:source_env] => :environment do |_t, args|
    source_env = args[:source_env] || :heroku
    pid = Pid.create_for_task(task_logger, 'dbdata-dump')

    begin
      if source_env == :heroku
        `heroku login`
        connection_string = `heroku pg:credentials:url | grep postgres`
        cmd = "pg_dump #{connection_string} > #{dumpfile(source_env)}"
        `#{cmd}`
        puts "Imported data from Heroku to #{dumpfile(source_env)}"
      else
        source = Rails.application.config.database_configuration[source_env.to_s]
        STDOUT.puts "Please enter the username for #{source['database']}:"
        username = STDIN.gets.chomp
        STDOUT.puts "Please type the password for #{username}:"
        password = STDIN.gets.chomp
        options = '--verbose --column-inserts --data-only'

        cmd = "PGPASSWORD=\"#{password}\" pg_dump -U  #{source['database']} -h "\
              "#{source['host']} -p #{source['port']}  #{options} >"\
              " #{dumpfile(source_env)}"
        output = `#{cmd}`
        if output.match?(/fatal/i)
          task_logger.fatal(output)
          raise Errno::ECONNREFUSED
        end
        puts "Imported data from AWS RDS to #{dumpfile(source_env)}"
      end
    ensure
      pid.delete
    end
  end

  desc 'Restore target db data to development'
  task :restore, %i[source_env target_env] => :environment do |_t, args|
    source_env = args[:source_env] || :heroku
    target_env = args[:target_env] || :development

    pid = Pid.create_for_task(task_logger, 'dbdata-restore')
    DumpProcessor.new(dumpfile(source_env.to_s), bulkfile(source_env.to_s)).process
    begin
      target = Rails.application.config.database_configuration[target_env.to_s]
      Rake::Task['db:drop'].execute
      Rake::Task['db:create'].execute
      Rake::Task['db:migrate'].execute
      cmd1 = "psql -h localhost -U postgres #{target['database']} < #{bulkfile(source_env)}"
      `#{cmd1}`
      cmd2 = "cat #{dumpfile} | grep setval | psql -h localhost -U postgres #{target['database']}"
      `#{cmd2}`
      puts "Imported source dump data in #{target_env}"
      File.delete(bulkfile(source_env))
      puts "Bulkfile removed successfully (#{bulkfile(source_env)})"
      puts "Remember to delete the dump file if you don't need it anymore (#{dumpfile(source_env)})"
      `RAILS_ENV=test rake db:drop db:create db:migrate RAILS_ENV=test`
    ensure
      pid.delete
    end
  end
end
