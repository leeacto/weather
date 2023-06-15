# README

A simple weather application for US locations.

### Requirements
* Ruby 3.2.2
* Redis
* Postgresql

### Setup
1. Run `git clone git@github.com:leeacto/weather.git` on your command line to download code
1. Run `bundle install` to install Ruby gems
1. Run `rails db:create` to create local database. None is currently used, but may be in the future
1. Tests can be run with `rails spec`

### Notes about the Application
* Addresses are geocoded to latitude/longitude using an API at the US Census
    a. International addresses will not work
    b. The API is flexible but not perfect. This means that typos may not return a result
    c. In the future an [address widget](https://developers.google.com/maps/documentation/javascript/place-autocomplete) like that of Google Maps may prevent errors
* Weather data comes from the [National Weather Service API](https://www.weather.gov/documentation/services-web-api)
    a. API is free, but NWS implements a rate limit. Retries are up to the user, but alternatives may be needed at scale
* Searches are cached for 30 minutes based on ZIP code
* API is versioned, so changes can be made without downtime
* Additional weather data is returned from the API but not used. It can be added by updating Javascript and HTML
