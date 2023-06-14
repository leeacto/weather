class Geocoder
  # API wrapper for US Census Geocoding; World requires payment

  include HTTParty
  base_uri "https://geocoding.geo.census.gov"

  class << self
    def locate(address)
      options = {
        address:,
        benchmark: "Public_AR_Current",
        format: "json",
      }
      response = self.get("/geocoder/locations/onelineaddress", query: options)

      first_match = response.dig("result", "addressMatches").first

      return nil unless first_match

      {
        address: first_match["matchedAddress"],
        zip: first_match.dig("addressComponents", "zip"),
        lat: first_match.dig("coordinates", "y"),
        lon: first_match.dig("coordinates", "x"),
      }
    end
  end
end
