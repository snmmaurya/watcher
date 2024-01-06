require 'filewatcher'
class CustomFileWatcher

  def start_watcher
    Filewatcher.new(['./sample.txt']).watch do |changes|
      change = changes.first
      filename = change[0]
      event = change[1]
      if event == :updated
        lines = added_lines(filename)
        ulines = lines
        if ulines.present?
          ulines = ulines.join("")
          RedisService.get_subscribers.each do |visitor|
            ActionCable.server.broadcast "watcher-#{visitor}", {message: ulines, visitor: visitor}
          end
        end
      end
      next
    end
  end

  def added_lines file_path, total_lines=nil
    file_content = File.open(file_path).readlines
    total_lines = total_lines || file_content.length

    @last_known_line_position ||= initial_line_position(total_lines)

    start_position = @last_known_line_position

    @last_known_line_position = total_lines

    file_content[start_position, total_lines]
  end

  def initial_line_position total_lines
    return 0 if total_lines.zero? || total_lines <= 10
    # print last 10 lines from the file if event is emitted for the first time
    total_lines - 10
  end

end
