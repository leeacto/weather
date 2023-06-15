require 'weather_service'

module Api
  module V1
    class ForecastsController < ApplicationController
      def show
        data = WeatherService.forecast(params.require(:address))

        render json: data
      end
    end
  end
end
