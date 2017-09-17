
[![Build Status](https://travis-ci.org/paramadeep/poisol.svg?branch=master)](https://travis-ci.org/paramadeep/poisol) [![Dependency Status](https://gemnasium.com/paramadeep/poisol.svg)](https://gemnasium.com/paramadeep/poisol) [![Code Climate](https://codeclimate.com/github/paramadeep/poisol/badges/gpa.svg)](https://codeclimate.com/github/paramadeep/poisol) 

# Poisol
Poisol provides builder DSL to stub http endpoints. Similar to models and fixtures (factorygirl) used to set test data in database. 

## Why yet another stub
Using other stub frameworks, had to do clumsy manipulation of the url's and json's to setup different scenarios for tests. 

Poisol is a logical evolution in an attempt to define base stub data, and a most flexible/precise DSL to specify the required variation. 

### Example

Stubbing a http service that provides user identification, gets as simple as 

```ruby
  User.new.for_name('Joe').has_role('buyer').build  
  # => stub http://localhost:3030/user?name=Joe that returns {"role":"buyer"}
  
  User.new.for_name('Mani').has_role('Manager').build 
  # => stub http://localhost:3030/user?name=Mani that returns {"role":"Manager"}
  
  User.new.build 
  # => stub http://localhost:3030/user?name=Raji that returns {"role":"Singer"}
```
given a minimal configuration

```yaml
#user.yml
request:
  url: user
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
  - query params
  - request body
- Response 
  - status code
  - header*
  - response body

## Usage

In your project Gemfile add

``` 
gem 'poisol'
```

### Cucumber

```ruby
#features/support/env.rb
require 'poisol'
```
```ruby
#suppoert/hooks.rb
Before do
  if $poisol_loaded.blank?
    Poisol.start #starts the stub server
    Poisol.load "stubs/cost"
    #Poisol.load "<--location of the stub configs folder-->" 
    #loads the configs as stub builders 
    $poisol_loaded = true
  end
  Poisol.reset_data
  #clears the stubs configured prior, hence every test is independent
end

at_exit do
  Poisol.stop
end
```
### Rspec

```ruby
#spec/spec_helper.rb
require 'poisol'

RSpec.configure do |config|

  config.before(:each) do
    Poisol.reset_data 
    #clears the stubs configured prior, hence every test is independent
  end

  config.before(:suite) do
    Poisol.start #starts the stub server
    Poisol.load "stubs/cost"
    #Poisol.load "<--location of the stub configs folder-->" 
    #loads the configs as stub builders 
  end

  config.after(:suite) do
    Poisol.stop
  end

end
```
### Port
  By default, on Poisol.start will start the stub server in port 3030, we can change the default port.
```ruby
Poisol.start(:port=>3333)
#=> Stub server runs with address http://localhost:3333
```

####Stubs  Config 
  For each service that is stubbed, configuration of all endpoints are kept inside corresponding service's folder.
```ruby 
    Poisol.load "<--location of the stub configs folder-->"
    #loads the configs as stub builders 
    #Poisol.load "stubs/cost"
    #Poisol.load "stubs/exchange"
    #Poisol.load "stubs/sms"
```
The below stubs folder will yield

1. Cost service servers two enpoints. Gross Cost and Net Cost.
2. Excahange service serves two endpoints. Rupee and Yen. 
3. SMS service service serves one endpoint. Send SMS. 
```
.
── stubs
   ├── cost 
   │   ├── domain.yml
   │   └── gross_cost.yml
   │   └── net_cost.yml
   ├── exchange 
   │   ├── domain.yml
   │   └── rupee.yml
   │   └── yen.yml
   └── sms 
       ├── domain.yml
       └── send_sms.yml

```
#### Domain
  In the above example each service folder contains a file called "domain.yml" which contain domain information of a specific service.

```yml
#stubs/cost/domain.yml
sub_domain: "cost"
```
hence cost service will be served at url, "http://localhost:3030/cost"

```yml
#stubs/exchange/domain.yml
sub_domain: "exchange/currency"
```
hence exchange service will be served at url, "http://localhost:3030/exchange/currency"

## Builders
 For every stub configuration file as they are loaded by Poisol, a builder class gets created dynamically. Which on building creates a stub for the endpoint.
 ```ruby 
 #cost\gross_cost.yml => GrossCost
 GrossCost.new.build
 #sms\send_sms.yml => SendSms
 SendSms.new.build 
 ```
 By default, without any modifiers mentioned, builder builds stub for the endpoint with the default values as mentioned in the configuration file.

### URL  
  ```yml
  #cost/gross_cost.yml
  request:
    url: gross/{article|"soap"}/{area|"chennai"}
    method: get
  response:
    body: '{"hi"}'
```

```ruby
GrossCost.new.build 
#=> builds localhost:3030/cost/gross/soap/chennai
```
Using "of_[place_holder]" method corresponding value can be modified.
```ruby
GrossCost.new.of_article("tooth_paste").of_area("mumbai").build 
#=> builds localhost:3030/cost/gross/tooth_paste/mumbai
``` 
### Query Params
```yml
#cost/gross_cost.yml
request:
  url: gross
  query:
    article: "soap"
    area: "chennai"
response:
  body: '{"hi"}'
```
```ruby
GrossCost.new.build                      
#=> builds localhost:3030/cost/gross?article=soap&area=chennai
```
Using "for_[param_name]" method corresponding query param value can be modified.
```ruby
GrossCost.new.for_article("tooth_paste").build 
#=> builds  localhost:3030/cost/gross?article=tooth_paste&area=chennai
GrossCost.new.for_area("mumbai").build 
#=> builds  localhost:3030/cost/gross?article=soap&area=mumbai
```
Using "for" method which takes a hash-map as parameter, all or partial list of query params can be modified.
```ruby
GrossCost.new.for({article=>"tooth_paste",:area=>"mumbai"}).build
#=> builds  localhost:3030/cost/gross?article=tooth_paste&area=mumbai
GrossCost.new.for({:area=>"mumbai"}).build 
#=> builds  localhost:3030/cost/gross?article=soap&area=mumbai
```
If some of your query params are optional, you can require them to be explicitly declared using the `query_explicit` directive.
```yml
request:
  url: book_explicit
  method: get
  query_explicit: true
  query:
    author: "bharathi"
    name: "doni"
response:
  body:  '{
    "title": "independance",
    "category": {
      "age_group": "10",
      "genre": "action",
      "publisher": {
        "name": "summa",
        "place":"erode"
      }
    }
  }'
```
```ruby
BookExplicit.new.for_author('bha').build()
#=> builds  http://localhost:3030/book_explicit?author=bha
```
Note that the `name` query parameter is not explicitly declared and is therefore ignored.
### Status
```yml
#cost/gross_cost.yml
request:
  url: gross
response:
  body: '{"hi"}'
```
When no status is mentioned, the default status is 200
```ruby
GrossCost.new.build 
#=> builds localhost:3030/cost/gross which returns status 200
```
Using "status" method, status value is modified 
```ruby
GrossCost.new.status(404).build 
#=> builds localhost:3030/cost/gross which returns status 404
```
### Response Body 
```yml
#cost/gross_cost.yml
request:
  url: gross
response:
  body: '{
  "cost":2,
  "currency":"rupee"
  }'
```
```ruby
GrossCost.new.build 
#=> builds localhost:3030/cost/gross which returns {"cost":2,"currency"=>"rupee"}
```
Using "has_[field_name]" method value of the field can be modified.
```ruby
GrossCost.new.has_cost(10).has_currency("dollar").build 
#=> builds localhost:3030/cost/gross which returns {"cost":10,"currency":"dollar"}
GrossCost.new.has_currency("pound").build 
#=> builds localhost:3030/cost/gross which returns {"cost":2,"currency":"pound"}
```
Using "has" method which takes a hash-map as parameter, all or partial list of fields can be modified.
```ruby
GrossCost.new.has(:cost=>10,:currency=>"dollar").build 
#=> builds localhost:3030/cost/gross which returns {"cost":10,"currency":"dollar"}
GrossCost.new.has(:currency=>"pound").build 
#=> builds localhost:3030/cost/gross which returns {"cost":2,"currency":"pound"}
```
###### [Handling array in response body](https://github.com/paramadeep/poisol/wiki/Response-Body)
### Request Body
```yml
#cost/gross_cost.yml
request:
  url: gross
  method: post
  body: '{
  "article":"soap",
  "cost":1
  }'
```
```ruby
GrossCost.new.build 
#=> builds post localhost:3030/cost/gross which takes {"aticle":"soap","cost"=>1}
```
Using "by_[field_name]" method value of the field can be modified.
```ruby
GrossCost.new.by_cost(10).by_article("tooth_paste").build 
#=> builds post localhost:3030/cost/gross which takes {"aticle":"tooth_paste","cost"=>10}
GrossCost.new.by_cost(2).build 
#=> builds post localhost:3030/cost/gross which takes {"aticle":"soap","cost"=>2}
```
Using "by" method which takes a hash-map as parameter, all or partial list of fields can be modified.
```ruby
GrossCost.new.by(:cost=>10,:article=>"tooth_paste").build 
#=> builds post localhost:3030/cost/gross which takes {"aticle":"tooth_paste","cost"=>10}
GrossCost.new.by(:cost=>2).build 
#=> builds post localhost:3030/cost/gross which takes {"aticle":"soap","cost"=>2}
```
###### [Handling array in request body](https://github.com/paramadeep/poisol/wiki/Request-Body)

## Prepositions

| Preposition | for defining                   |
| ----:       | :----                          |
| of          | url                            |
| for         | query params                   |
| by          | request body filed/array item  |
| having      | request body array item field  |
| has         | response body field/array item |
| with        | response body array item field |



## ToDo
* Allow regex defenition and matching of request
* Use part of request as part of response, dynamically.
* Setting response for multiple hits.
* Configuring time delay for responses
* Make header configurable 
* Ensure contract mentioned cannot be changed
