require 'geocoder'
require 'weather_forecast'

class WeatherService
  # Retrieve weather forecast data given a US address
  class << self
    def forecast(address)
      geocoded = Geocoder.locate(address)
      weather_data = WeatherForecast.forecast(geocoded[:lat], geocoded[:lon])

      weather_data.merge(geocoded)
    end
  end
end
