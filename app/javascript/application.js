// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "jquery"
import "jquery_ujs"
import "popper"

const API_VERSION = 1;

$(document).ready(function() {
  const $searchForm = $("#address-form");
  let forecastPeriod = function(data) {
    const date = new Date(data.startTime);
    const pdNameHtml = '<span class="pd-name">' + data.name + '</span>';
    const dateHtml = '<span class="pd-date">' + date.getMonth() + '/' + date.getDate() + '</span>';
    const picHtml = '<img class="pd-pic" src="' + data.icon + '" />';
    const tempHtml = '<span class="pd-temp">' + data.temperature + '&deg; ' + data.temperatureUnit + '</span>';
    return '<div class="forecast-pd">' +  pdNameHtml + '<br>' + dateHtml + '<br>' + picHtml + '<br>' + tempHtml + '</div>';
  };
  $searchForm.submit(function(e) {
    e.preventDefault();

    const address = $("#address").val();
    $.get("/api/v" + API_VERSION + "/forecast", { address: address }).done(function(data) {
      if (data) {
        $("#forecast-holder").empty();
        $("#address").val('');
        $("#location").text(data.address);
        $("#updated-at").text(new Date(data.updated_at).toLocaleString());
        $("#current-temp").text(data.current.temperature + '\xB0 ' + data.current.temperatureUnit);
        $("#short-forecast").text(data.current.shortForecast);
        $("#rain-chance").text(data.current.probabilityOfPrecipitation.value + "%");
        $("#wind").text(data.current.windSpeed + " " + data.current.windDirection);

        const firstTwelve = data.forecast.slice(0, 12);
        firstTwelve.forEach((forecast) => {
          let fc = forecastPeriod(forecast);
          $("#forecast-holder").append(fc);
        });
      } else {
        alert("Address not found");
      }
    }).error(function() {
      alert("Address not found");
    }).always(function() {
      $($("#address-form").find('input')[1]).prop('disabled', false)
    });
  });
})
