// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "jquery"
import "jquery_ujs"
import "popper"
import "bootstrap"

$(document).ready(function() {
  const $searchForm = $("#address-form");
  let forecastPeriod = function(data) {
    const pdNameHtml = '<span class="pd-name">' + data.name + '</span';
    const picHtml = '<img class="pd-pic" src="' + data.icon + '" />';
    const tempHtml = '<span class="pd-temp">' + data.temperature + ' ' + data.temperatureUnit + '</span>';
    return '<div class="forecast-pd col-sm-3">' +  pdNameHtml + '<br>' + picHtml + '<br>' + tempHtml + '</div>';
  };
  $searchForm.submit(function(e) {
    e.preventDefault();

    const address = $("#address").val();
    $.get("/api/forecast", { address: address }).done(function(data) {
      console.log(data);
      $("#address").val('');
      $("#location").text(data.address);
      $("#updated-at").text(new Date(data.updated_at));
      $("#current-temp").text(data.current.temperature + " " + data.current.temperatureUnit);
      $("#short-forecast").text(data.current.shortForecast);
      $("#rain-chance").text(data.current.probabilityOfPrecipitation.value + "%");
      $("#wind").text(data.current.windSpeed + " " + data.current.windDirection);

      const firstTwelve = data.forecast.slice(0, 12);
      firstTwelve.forEach((forecast) => {
        let fc = forecastPeriod(forecast);
        $("#forecast-holder").append(fc);
      });
    }).error(function() {
      alert("Address not found");
    });
  });
})
import * as bootstrap from "bootstrap"
