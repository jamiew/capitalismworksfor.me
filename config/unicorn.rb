worker_processes Integer(ENV['UNICORN_WORKERS'] || 4)
listen ENV['PORT'], backlog: Integer(ENV['UNICORN_BACKLOG'] || 25)
timeout 25
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  if defined?($redis)
    $redis.shutdown { |conn| conn.quit }
  end
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end

  if defined?(Redis) && defined?(ConnectionPool)
    $redis = RedisConnectionPool.build
  end
end
