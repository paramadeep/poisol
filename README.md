
[![Build Status](https://travis-ci.org/paramadeep/poisol.svg?branch=master)](https://travis-ci.org/paramadeep/poisol) [![Dependency Status](https://gemnasium.com/paramadeep/poisol.svg)](https://gemnasium.com/paramadeep/poisol) [![Code Climate](https://codeclimate.com/github/paramadeep/poisol/badges/gpa.svg)](https://codeclimate.com/github/paramadeep/poisol) 

#Poisol

For tests suite that uses stubs for http calls, Poisol generates builder objects that could be used to setup http stubs, similar to data builders used to set up test data in database. 

Hence, avoiding clumsy manual json manipulations and duplications, and keeping test stub data setup as part of test's code.

###Example

Stubbing a http service that provides user identification, gets as simple as 

```ruby
  User.new.byName('Joe').hasRole('buyer').build  
  # => webmock that would return role as 'buyer' for http call user 'Joe'
  
  User.new.byName('Mani').hasRole('Manager').build 
  # => webmock that would return role as 'Manager' for http call user 'Mani'
  
  User.new.build 
  # => webmock that would return role as 'Singer' for http call user 'Raji'
```
given a minimal configuration

```yaml
#user.yml
url: http://authentication.service:80/user
query: 
  name: "Raji"
response_body:
  '{
      role: "singer"
  }'
```
Poisol, dynamically generates class called 'User', with methods 'byName' and 'hasRole', which can be used to build as many User's as we need for the tests.

The following can be dynamically configured
- Request 
  - url
  - type
  - query params
  - request body
- Response 
  - code
  - header
  - response body

## Prepositions

|Preposition| for defining|
|----:|:----|
|of|url |
|for|query params |
|by|request body filed/array item|
|having|request body array item field|
|has|response body field/array item|
|with|response body array item field|

##ToDo
* Response code and header config
* Functional test for query params
* Refactor Response Handler 
* Generate Request Handler, based on Response Handler
* Documentation for 'getting started' and details
* Test coverage
* Throw error when configured and input field values are different
