module Stubs
  extend self

  def add stub 
    @stubs = [] if @stubs.blank?
    @stubs << stub 
  end

  def reset
    @stubs = []
  end

  def get_match request
    return nil if @stubs.blank?
    matches = @stubs.select{|stub| stub.request.url == request.url }
    matches = matches.select{|stub|query_matches?(request.query,stub.request.query)} if request.query.present? && matches.present?
    matches = matches.select{|stub|body_matches? request.body,stub.request.body} if request.body.present? && matches.present?
    return matches.present? ? matches[0] : nil 
  end

  def query_matches? (actual,stub)
    return false if stub.blank?
    return actual==stub 
  end

  def body_matches? (actual_request_body,stub_request_body)
    return true if stub_request_body.present? && actual_request_body == stub_request_body
    return false if stub_request_body.blank?
    actual_request_body = load_as_json actual_request_body
    stub_request_body = load_as_json stub_request_body
    return false unless actual_request_body.class == stub_request_body.class
    return matching_hashes? actual_request_body,stub_request_body if actual_request_body.is_a?(Hash)
    return matching_array? actual_request_body,stub_request_body if actual_request_body.is_a?(Array)
    return false
  end

  def load_as_json input
    require 'json'
    begin
      return JSON.parse input
    rescue
      return input
    end
  end


  def matching_hashes?(query_parameters, pattern)
    return false unless query_parameters.is_a?(Hash)
    return false unless query_parameters.keys.sort == pattern.keys.sort
    query_parameters.each do |key, actual|
      expected = pattern[key]

      if actual.is_a?(Hash) && expected.is_a?(Hash)
        return false unless matching_hashes?(actual, expected)
      else
        return false unless expected === actual
      end
    end
    true
  end

  def matching_array actuals,expected
    return false unless actuals.size == expected.size
    return actuals.sort == expected.sort unless actual[0].is_a(Hash)
    expect = expected.clone
    actuals.each do |actual|
      match = expect.detect {|pattern| matching_hashes? actual,expect}
      return false if match.blank?
    end
  end
end
