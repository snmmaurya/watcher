class LogsController < ApplicationController
  def watch
    @visitor = params[:visitor]
    custom_file_watcher = CustomFileWatcher.new
    @lines = custom_file_watcher.added_lines("./sample.txt", 10)
  end
end
