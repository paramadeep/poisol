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
      matches = @stubs.select{|stub| RequestMatcher.matches? actual_request,stub.request}
      return nil unless matches.present?
      match = matches.last
      match.called_count = match.called_count + 1
      return match
    end

    def unused
      @stubs.select{|stub| stub.called_count ==0}
    end

  end
end
