# iDBUS API wrapper

[![Build Status](https://travis-ci.org/paulRbr/idbus_api.svg)](https://travis-ci.org/paulRbr/idbus_api) [![Coverage Status](https://coveralls.io/repos/paulRbr/idbus_api/badge.svg)](https://coveralls.io/r/paulRbr/idbus_api) [![Gem Version](https://badge.fury.io/rb/idbus_api.svg)](http://badge.fury.io/rb/idbus_api)

## Description

This gem wraps the new iDBUS API v1 available at https://api.idbus.com

## Installation

You can use this gem in your project by specifying it in your `Gemfile`:

```
gem "idbus_api"
```

or simply install it via the CLI:

```
gem install idbus_api
```

## Usage

All the API methods are available as module methods or as client instance methods.

### Configure the client

```ruby
IdbusApi.configure do |c|
  c.access_token = "my_secret_token"
  c.connection_options = {
    ssl: { verify: false }
  } # Hash of Faraday ConnectionOptions. See http://www.rubydoc.info/github/lostisland/faraday/Faraday/Connection#initialize-instance_method
  c.user_agent = "My App"
end

# Fetch all stops
IdbusApi.stops
```

or

```ruby
client = IdbusApi::Client.new(
  access_token: "my_secret_token",
  user_agent: "My App"
)

# Fetch fares
client.fares(date: "2015-07-07")
```

### Fetching resources

All resources are `Resource` objects. This object provides both dot notation and `[]` access for the api response fields.

#### Stops

```ruby
# Fetch stops from /v1/stops endpoint
stops = IdbusApi.stops

stops.first.short_name == "Paris CDG (aéroport)"
```

#### Fares

Fares can be fetched with optional parameters. Full list of available parameters is available on the api documentation https://api.idbus.com/.

```ruby
# Fetch fares for specific origin station and specific date
fares = IdbusApi.fares(origin_id: 3, date: "2015-08-15")

fares.first.price_cents
 => 1500

fares.first.to_hash
 => {
      :id => 13864,
      :updated_at => 2015-06-11 07:55:22 UTC,
      :origin_id => 3,
      :destination_id => 13,
      :departure => "2015-08-15T08:40:00.000+02:00",
      :arrival => "2015-08-15T12:55:00.000+02:00",
      :price_cents => 1500,
      :price_currency => "EUR",
      :book_path => "/v1/fares/13864/book",
      :available => true,
      :legs => [{:origin_id=>3, :destination_id=>13, :departure=>"2015-08-15T08:40:00.000+02:00", :arrival=>"2015-08-15T12:55:00.000+02:00", :bus_number=>"3912"}]
    }
```

## Disclaimer

Neither I, nor any developer who contributed to this project, accept any kind of liability for your use of this library.

_This gem is not endorsed or affiliated with any company, api.idbus.com, nor iDBUS, nor SNCF._

## License

Code licensed under [MIT-LICENSE](https://github.com/paulrbr/idbus_api/blob/master/MIT-LICENSE)
