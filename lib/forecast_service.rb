require 'geocoder'

class ForecastService
  def initialize
    @geocoder = Geocoder.new
  end
end
