require_relative './request_matcher'
module Poisol 
  module Stubs
    extend self

    def all
      @stubs
    end

    def add stub 
      @stubs = [] if @stubs.blank?
      @stubs << stub 
    end

    def reset
      @stubs = []
    end

    def get_match actual_request
      return nil if @stubs.blank?
      matches = @stubs.select{|stub| Poisol::RequestMatcher.matches? actual_request,stub.request}
      return matches.present? ? matches[0] : nil 
    end


  end
end
