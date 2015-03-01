# Response Body 
 Stubbing simple response body is explained here. This page explains stubbing of
 - Array Filed
 - Nested Array Filed
 - Array Object
 - Array Object with nested array


## Array Filed
In the below example response body has a field that is of type array

Important: mention just a single value of array in the config. 
```yml
#cost/gross_cost.yml
request:
  url: gross
response:
  body: '{
  "cost":[10]
  }'
```
```ruby
GrossCost.new.build 
GrossCost.new.has_cost.build 
#=> builds localhost:3030/cost/gross which returns 
#{"cost":[10]}
```
Note: In above example, both the statements results the same response. By default, array fields assigns values as mentioned in config. And the first modifier "has_[field_name]" does the same. 

Multiple values can be added like by calling "has_[field_name]" consecutively, or passing an array of values to "has_[field_name]" method
```ruby
GrossCost.new.has_cost.has_cost(20).build 
#=> which returns {"cost":[10,20]}
GrossCost.new.has_cost(30).has_cost(20).build 
#=> which returns {"cost":[30,20]}
GrossCost.new.has_cost([30,20]).build 
#=> which returns {"cost":[30,20]}
```

## Nested Array Field
In the below example response body has a field that is of type array of object. It works the same as the above, just that it has extra modifier for the nested objects.

Important: mention just a single value of array in the config. 
```yml
#cost/gross_cost.yml
request:
  url: gross
response:
  body: '{
  "cost":[{"article":"soap","value":1}]}'
```
```ruby
GrossCost.new.build 
GrossCost.new.has_cost.build 
#=> builds localhost:3030/cost/gross which returns 
#{"cost":[{"article":"soap","value":1}]}
```
Note: In above example, both the statements results the same response. By default, array fields assigns values as mentioned in config. And the first modifier "has_[field_name]" does the same. 

Multiple values to the array can be added by calling the "has_[field_name]" method consecutively. 
```ruby
GrossCost.new.
  has_cost(:value=>"10").
  has_cost(:article=>"shampoo",:value=>4).build 
#=> which returns 
#{"cost":[
# {"article":"soap","value":10},
# {"article":"shampoo","value":4}
#]}
```
"has_[filed_name]" method can also take array hash-map as parameter, all or partial list of fields can be modified.
```ruby
GrossCost.new.has_cost([{:value=>"10"},{:article=>"shampoo",:value=>4}].build 
#=> which returns 
#{"cost":[
# {"article":"soap","value":10},
# {"article":"shampoo","value":4}
#]}
```
"with_[nested_field]" method can assign value to the nested fields dierctly
```ruby
GrossCost.new.
  has_cost.with_value("10").
  has_cost.with_article("shampoo").with_value=(4).build 
#=> which returns 
#{"cost":[
# {"article":"soap","value":10},
# {"article":"shampoo","value":4}
#]}
```

## Array Object
The below endpoint return list of products, hence the response array of product object 
```yml
#products.yml
request:
  url: products 
response:
  array_type: row
  body: '{
    name: "soap"
    id: 10
  }'
