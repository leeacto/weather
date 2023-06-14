class WeatherCache
  class << self
    CACHE_TTL = 30.minutes.seconds.to_i

    def get_by_zip(zip)
      cached = $redis.get(zip)
      JSON.parse(cached) if cached
    end

    def set_by_zip(zip, data)
      $redis.set(zip, data.to_json)
      $redis.expire(zip, CACHE_TTL)
    end
  end
end
