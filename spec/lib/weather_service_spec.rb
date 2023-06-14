require 'weather_service'

RSpec.describe WeatherService do
  describe ".forecast" do
    before do
      @address = "123 fake st. springfield mo"
      @geocode_data = { lat: 39.7456, lon: -97.0892 }
    end

    it "calls Geocoder and WeatherForecast" do

      expect(Geocoder).to receive(:locate).with(@address).and_return(@geocode_data)

      weather_data = { current: 1, forecast: 2 }
      expect(WeatherForecast).to receive(:forecast).and_return(weather_data)


      WeatherService.forecast(@address)
    end

    it "returns nil for invalid Geocode" do
      expect(Geocoder).to receive(:locate).with(@address).and_return(nil)

      data = WeatherService.forecast(@address)
      expect(data).to be_nil
    end

    it "returns only Geocode data for invalid WeatherForecast" do
      expect(Geocoder).to receive(:locate).with(@address).and_return(@geocode_data)

      expect(WeatherForecast).to receive(:forecast).and_return(nil)

      data = WeatherService.forecast(@address)
      expect(data).to eq @geocode_data
    end
  end
end
