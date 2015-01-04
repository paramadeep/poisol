module Poisol
  class Stub
    attr_accessor :request,:response,:called_count
    def initialize
      called_count = 0
      @request = Request.new
      @response = Response.new
    end
  end
end
