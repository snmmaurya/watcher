load 'app/services/custom_file_watcher.rb'

redis_conn = proc {
  Redis.new(url: "redis://localhost:6379/0")
}

$redis = redis_conn.call


$custom_file_watcher = CustomFileWatcher.new
Thread.new do
  Rails.application.executor.wrap do
    $custom_file_watcher.start_watcher
  end
end