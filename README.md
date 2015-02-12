
[![Build Status](https://travis-ci.org/paramadeep/poisol.svg?branch=master)](https://travis-ci.org/paramadeep/poisol) [![Dependency Status](https://gemnasium.com/paramadeep/poisol.svg)](https://gemnasium.com/paramadeep/poisol) [![Code Climate](https://codeclimate.com/github/paramadeep/poisol/badges/gpa.svg)](https://codeclimate.com/github/paramadeep/poisol) 

#Poisol

Poisol provides DSL, with default builders, to stub http endpoints.Similar to Active records and fixtures (factorygirl) used to set test data in database. 

Hence, avoiding clumsy manual manipulations and duplications of url's & json, and keeping test stub data setup as part of test's code.

###Example

Stubbing a http service that provides user identification, gets as simple as 

```ruby
  User.new.for_name('Joe').has_role('buyer').build  
  # => stub that would return with role as 'buyer' for http call for user 'Joe'
  
  User.new.for_name('Mani').has_role('Manager').build 
  # => stub that would return with role as 'Manager' for http call for user 'Mani'
  
  User.new.build 
  # => stub that would return with role as 'Singer' for http call for user 'Raji'
```
given a minimal configuration

```yaml
#user.yml
request:
  url: http://authentication.service:80/user
  query: 
    name: "Raji"
response:
  body:'{
          role : "singer"
        }'
```
Poisol, dynamically generates class called 'User', with methods 'of_name' and 'has_role', which can be used to build as many User's as we need for the tests.

It handles complex request and responses, like array, nested array, array having nested array etc..

The following can be dynamically configured, through the builders available
- Request 
  - url
  - method*
  - query params
  - request body
- Response 
  - status code
  - header*
  - response body

## Prepositions

| Preposition | for defining                   |
| ----:       | :----                          |
| of          | url                            |
| for         | query params                   |
| by          | request body filed/array item  |
| having      | request body array item field  |
| has         | response body field/array item |
| with        | response body array item field |

##Usage

In your project Gemfile add

``` 
gem 'poisol'
```

###Cucumber

```ruby
#features/support/env.rb
require 'poisol'
```
```ruby
#suppoert/hooks.rb
Before do
  if $poisol_loaded.blank?
    Poisol.start #starts the stub server
    Poisol.load "<--location of the stub configs folder-->" #loads the configs as stub builders 
    #Poisol.load "features/stub_data/payment_gateway"
    #Poisol.load "features/stub_data/exchange_service"
    $poisol_loaded = true
  end
  Poisol.reset_data #clears the stubs configured prior, hence every test is independent
end

at_exit do
  Poisol.stop
end
```
###Rspec

```ruby
#spec/spec_helper.rb
require 'poisol'

RSpec.configure do |config|

  config.before(:each) do
    Poisol.reset_data #clears the stubs configured prior, hence every test is independent
  end

  config.before(:suite) do
    Poisol.start #starts the stub server
    Poisol.load "<--location of the stub configs folder-->" #loads the configs as stub builders 
    #Poisol.load "spec/stub_data/payment_gateway"
    #Poisol.load "spec/stub_data/exchange_service"
  end

  config.after(:suite) do
    Poisol.stop
  end

end
```
## Builders
####URL  
  ```yml
  #user.yml
  request:
    url: http://authentication.service:80/user/{id|2}
    ...
```

##ToDo
* Make header configurable 
* Ensure contract mentioned to not changed
