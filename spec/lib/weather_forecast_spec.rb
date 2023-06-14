require 'weather_forecast'

RSpec.describe WeatherForecast do
  describe ".weather_urls" do
    it "returns valid urls given valid lat/lon" do
      lat = 39.7456
      lon = -97.0892
      path = "http://api.weather.gov/points/#{lat},#{lon}"
      response_body = {
        "properties" => {
          "forecast" => "forecast_url",
          "forecastHourly" => "forecast_hourly_url",
        }
      }
      stub_request(:get, path).to_return(
        body: response_body.to_json,
        status: 200,
        headers: { content_type: 'application/json' })

      data = WeatherForecast.weather_urls(lat, lon)
      expect(data[:forecast]).to eq "forecast_url"
      expect(data[:hourly]).to eq "forecast_hourly_url"
    end

    it "returns nil given invalid lat/lon" do
      lat = 39.7456
      lon = -20000
      path = "http://api.weather.gov/points/#{lat},#{lon}"
      response_body = {
        "correlationId": "31cc296c",
        "title": "Invalid Parameter",
        "type": "https://api.weather.gov/problems/InvalidParameter",
        "status": 400,
        "detail": "Parameter \"point\" is invalid: '39.7456,-20000' does not appear to be a valid coordinate",
        "instance": "https://api.weather.gov/requests/31cc296c"
      }
      stub_request(:get, path).to_return(
        body: response_body.to_json,
        status: 400,
        headers: { content_type: 'application/json' })

      data = WeatherForecast.weather_urls(lat, lon)
      expect(data).to be_nil
    end
  end

  describe "#current_by_url" do
    it "returns the first forecast period given a valid URL" do
      url = "http://api.weather.gov/valid_url"
      response_body = {
        "properties" => {
          "periods" => [
            {
              "number" => 1,
              "name" => "",
              "startTime" => "2023-06-14T15:00:00-04:00",
              "endTime" => "2023-06-14T16:00:00-04:00",
              "isDaytime" => true,
              "temperature" => 78,
              "temperatureUnit" => "F",
              "temperatureTrend" => nil,
              "probabilityOfPrecipitation" => {
                "unitCode" => "wmoUnit:percent",
                "value" => 17
              },
              "dewpoint" => {
                "unitCode" => "wmoUnit:degC",
                "value" => 11.666666666666666
              },
              "relativeHumidity" => {
                "unitCode" => "wmoUnit:percent",
                "value" => 42
              },
              "windSpeed" => "16 mph",
              "windDirection" => "W",
              "icon" => "https://api.weather.gov/icons/land/day/tsra_hi,17?size=small",
              "shortForecast" => "Isolated Showers And Thunderstorms",
              "detailedForecast" => ""
            },
            {
              "number" => 2,
              "name" => "Dummy second",
            }
          ]
        }
      }
      stub_request(:get, url).to_return(
        body: response_body.to_json,
        status: 200
      )
      data = WeatherForecast.current_by_url(url)
      expect(data["number"]).to eq 1
    end

    it "returns nil given an invalid URL" do
      url = "http://api.weather.gov/invalid_url"
      stub_request(:get, url).to_return(
        body: '{}',
        status: 500
      )
      data = WeatherForecast.current_by_url(url)
      expect(data).to be_nil
    end
  end

  describe "#forecast_by_url" do
    it "returns all forecasts given a valid URL" do
      url = "http://api.weather.gov/valid_url"
      response_body = {
        "properties" => {
          "periods" => [
            {
              "number" => 1,
              "name" => "",
            },
            {
              "number" => 2,
              "name" => "Dummy second",
            }
          ]
        }
      }
      stub_request(:get, url).to_return(
        body: response_body.to_json,
        status: 200
      )
      data = WeatherForecast.forecast_by_url(url)

      expect(data.count).to eq 2
      expect(data[0]["number"]).to eq 1
      expect(data[1]["number"]).to eq 2
    end

    it "returns nil given an invalid URL" do
      url = "http://api.weather.gov/invalid_url"
      stub_request(:get, url).to_return(
        body: '{}',
        status: 500
      )
      data = WeatherForecast.forecast_by_url(url)
      expect(data).to be_nil
    end
  end

  describe ".forecast" do
    it "returns forecast data given a valid lat/lon" do
      lat, lon = 39.7456, -97.0892
      forecast_url = "http://api.weather.gov/forecast_url"
      forecast_hourly_url = "http://api.weather.gov/forecast_hourly_url"
      urls_path = "http://api.weather.gov/points/#{lat},#{lon}"
      urls_response_body = {
        "properties" => {
          "forecast" => forecast_url,
          "forecastHourly" => forecast_hourly_url,
        }
      }
      stub_request(:get, urls_path).to_return(
        body: urls_response_body.to_json,
        status: 200,
        headers: { content_type: 'application/json' }
      )

      forecast_response_body = {
        "properties" => {
          "periods" => [
            { "number" => 1, "name" => "", },
            { "number" => 2, "name" => "Dummy second", }
          ]
        }
      }
      stub_request(:get, forecast_url).to_return(
        body: forecast_response_body.to_json,
        status: 200
      )

      current_response_body = {
        "properties" => {
          "periods" => [
            { "number" => 1 }
          ]
        }
      }
      stub_request(:get, forecast_hourly_url).to_return(
        body: current_response_body.to_json,
        status: 200
      )

      data = WeatherForecast.forecast(lat, lon)
      expect(data[:current]).not_to be_nil
      expect(data[:forecast]).not_to be_nil
      expect(data[:forecast].count).to eq 2
    end

    it "returns nil for invalid lat/lon" do
      lat, lon = 39.7456, -20000
      urls_path = "http://api.weather.gov/points/#{lat},#{lon}"
      urls_response_body = { "status": 400 }
      stub_request(:get, urls_path).to_return(
        body: urls_response_body.to_json,
        status: 400,
        headers: { content_type: 'application/json' }
      )

      data = WeatherForecast.forecast(lat, lon)
      expect(data).to be_nil
    end
  end
end
