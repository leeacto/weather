require "rails_helper"

RSpec.describe Api::ForecastsController do
  describe "GET show" do
    it "requires an address parameter" do
      expect {
        get api_forecast_path
      }.to raise_error(ActionController::ParameterMissing)
    end

    it "calls the WeatherService given an address" do
      address = "123 fake st springfield mo"
      data = {
        address: "123 FAKE ST SPRINGFIELD MO 12345"
      }
      expect(WeatherService).to receive(:forecast).with(address).and_return(data)
      get api_forecast_path, params: { address: }

      json_body = JSON.parse(response.body)

      expect(json_body["address"]).to eq "123 FAKE ST SPRINGFIELD MO 12345"
    end
  end
end
