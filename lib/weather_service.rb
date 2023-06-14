require 'geocoder'
require 'weather_forecast'

class WeatherService
  # Retrieve weather forecast data given a US address
  class << self
    def forecast(address)
      geocoded = Geocoder.locate(address)
      return nil unless geocoded

      weather_data = WeatherForecast.forecast(geocoded[:lat], geocoded[:lon])
      return geocoded unless weather_data

      weather_data.merge(geocoded)
    end
  end
end
