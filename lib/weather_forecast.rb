class WeatherForecast
  # API wrapper for National Weather Service

  include HTTParty
  base_uri "api.weather.gov"

  class << self
    def forecast(lat, lon)
      urls = weather_urls(lat, lon)
      forecast_data = forecast_by_url(urls[:forecast])
      current_data = current_by_url(urls[:hourly])
      {
        current: current_data,
        forecast: forecast_data,
      }
    end

    def current_by_url(url)
      response = self.get(url)
      body = JSON.parse(response.body)
      body.dig("properties", "periods").first
    end

    def forecast_by_url(url)
      response = self.get(url)
      body = JSON.parse(response.body)
      body.dig("properties", "periods")
    end

    def weather_urls(lat, lon)
      response = self.get("/points/#{lat},#{lon}")
      body = JSON.parse(response.body)

      {
        forecast: body.dig("properties", "forecast"),
        hourly: body.dig("properties", "forecastHourly"),
      }
    end
  end
end
