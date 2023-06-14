require 'geocoder'

RSpec.describe Geocoder do
  describe ".locate" do
    before do
      @path = "https://geocoding.geo.census.gov/geocoder/locations/onelineaddress?address=123%20fake%20st.%20springfield%20mo&benchmark=Public_AR_Current&format=json"
      @address = "123 fake st. springfield mo"
    end

    it "returns data given valid address" do
      response = {
        "result" => {
          "addressMatches" => [
            {
              "matchedAddress" => "123 FAKE ST. SPRINGFIELD, MO 98765",
              "addressComponents" => { "zip" => "98765" },
              "coordinates" => { "x" => -30.189555, "y" => 18.297165 }
            }
          ]
        }
      }
      stub_request(:get, @path).to_return(
        body: response.to_json,
        headers: { content_type: 'application/json' })
      data = Geocoder.locate(@address)

      expected_address = response.dig("result", "addressMatches").first
      expect(data[:address]).to eq expected_address["matchedAddress"]
      expect(data[:zip]).to eq expected_address.dig("addressComponents", "zip")
      expect(data[:lat]).to eq expected_address.dig("coordinates", "y")
      expect(data[:lon]).to eq expected_address.dig("coordinates", "x")
    end

    it "returns nil for unmatched addresses" do
      response = {
        "result" => { "addressMatches" => [] }
      }
      stub_request(:get, @path).to_return(
        body: response.to_json,
        headers: { content_type: 'application/json' })
      data = Geocoder.locate(@address)
      expect(data).to be_nil
    end
  end
end
