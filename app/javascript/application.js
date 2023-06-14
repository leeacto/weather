// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "jquery"
import "jquery_ujs"
import "popper"
import "bootstrap"

$(document).ready(function() {
  var $searchForm = $("#address-form");
  $searchForm.submit(function(e) {
    e.preventDefault();

    var address = $("#address").val();
    $.get("/api/forecast", { address: address }).done(function(data) {
      console.log(data);
      $("#location").text(data.address);
      $("#updated-at").text(data.updated_at);
      $("#current-temp").text(data.current.temperature + " " + data.current.temperatureUnit);
    }).error(function() {
      alert("Address not found");
    });
  });
})
