class RedisService
  class << self
    def set_subscribers subscriber
      data = RedisService.get_subscribers
      datum = (data + [subscriber]).uniq
      $redis.hmset "watcher", "subscribers", datum.to_json
    end

    def get_subscribers
      if data = $redis.hget("watcher", "subscribers")
        datum = JSON.parse(data)
      else
        datum = []
      end
      datum
    end
  end
end