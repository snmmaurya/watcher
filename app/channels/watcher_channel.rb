require 'filewatcher'
class WatcherChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug("----------- subscribed ------ #{params}")
    RedisService.set_subscribers(params[:visitor])
    stream_from "watcher-#{params[:visitor]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speek(data)
    Rails.logger.debug("Inside speek method---- #{data}")
  end

end