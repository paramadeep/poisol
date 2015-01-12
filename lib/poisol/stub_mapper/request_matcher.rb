module Poisol 
  module  RequestMatcher
    extend self 

    def matches? actual_req,stub_req 
      type_matches?(actual_req,stub_req) &&
        url_macthes?(actual_req,stub_req) &&
        query_matches?(actual_req,stub_req) &&
        body_matches?(actual_req,stub_req)
    end

    def type_matches? actual_req,stub_req
      actual_req.type == stub_req.type
    end

    def url_macthes? actual_req,stub_req
      actual_req.url == stub_req.url
    end

    def query_matches? actual_req,stub_req 
      return true if  actual_req.query==stub_req.query
      actual_query = CGI::parse(actual_req.query)
      stub_query = CGI::parse(stub_req.query)
      return matching_hashes? actual_query,stub_query
    end

    def body_matches? actual_req,stub_req
      return true if actual_req.body == stub_req.body
      actual_req_body = load_as_json actual_req.body
      stub_req_body = load_as_json stub_req.body 
      return false unless actual_req_body.class == stub_req_body.class
      return true if actual_req_body == stub_req_body 
      return matching_hashes? actual_req_body,stub_req_body if actual_req_body.is_a?(Hash)
      return matching_array? actual_req_body,stub_req_body if actual_req_body.is_a?(Array)
    end

    def load_as_json input
      begin
        return Parse.json_to_hash input
      rescue
        return input
      end
    end


    def matching_hashes?(actuals, expected)
      return false unless actuals.keys.sort == expected.keys.sort
      actuals.each do |key, actual|
        expect = expected[key]

        if actual.is_a?(Hash) && expect.is_a?(Hash)
          return false unless matching_hashes?(actual, expect)
        else
          return false unless expect === actual
        end
      end
      true
    end

    def matching_array actuals,expected
      return false unless actuals.size == expected.size
      return actuals.sort == expected.sort unless actual[0].is_a(Hash)
      expect = expected.clone
      actuals.each do |actual|
        match = expect.detect {|expected| matching_hashes? actual,expect}
        return false if match.blank?
      end
    end

  end
end
