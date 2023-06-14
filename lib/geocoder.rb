class Geocoder
  # API wrapper for US Census Geocoding; World requires payment

  include HTTParty
  base_uri "https://geocoding.geo.census.gov"

  def initialize
  end

  def locate(address)
    options = {
      address:,
      benchmark: "Public_AR_Current",
      format: "json",
    }
    response = self.class.get("/geocoder/locations/onelineaddress", query: options)

    response.dig("result", "addressMatches").first
  end
end
