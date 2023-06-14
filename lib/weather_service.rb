require 'geocoder'
require 'weather_cache'
require 'weather_forecast'

class WeatherService
  # Retrieve weather forecast data given a US address
  class << self
    def forecast(address)
      geocoded = Geocoder.locate(address)
      return nil unless geocoded

      zip = geocoded[:zip]
      cached = WeatherCache.get_by_zip(zip)
      return cached if cached

      return_data = geocoded

      weather_data = WeatherForecast.forecast(geocoded[:lat], geocoded[:lon])
      return return_data unless weather_data

      return_data.merge!(weather_data, updated_at: Time.now)
      WeatherCache.set_by_zip(zip, return_data)

      return_data
    end
  end
end
