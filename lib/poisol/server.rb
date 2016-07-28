module Poisol

  class ExtendedServer  < WEBrick::HTTPServlet::AbstractServlet
    def do_GET req,res
      stub_response = Poisol::ResponseMapper.map(req)
      res.status = stub_response.status
      res.body = stub_response.body.to_json
      res.header.merge! stub_response.header
    end
    alias do_DELETE do_GET
    alias do_POST do_GET
    alias do_PUT do_GET
  end

  module Server
    extend self

    def start port
      PoisolLog.info "Starting server...  as http://localhost:#{port}"
      @server =  WEBrick::HTTPServer.new :Port => port, :Logger => log, :AccessLog => access_log
      @port = port
      attach_shutdown
      attach_request_handling
      Thread.new{@server.start}
      PoisolLog.info "Server Started at http://localhost:#{port}"
    end

    def base_url
      "http://localhost:#{@port}"
    end

    def attach_request_handling
      @server.mount '/', ExtendedServer
    end

    def attach_shutdown 
      trap 'INT' do @server.shutdown end
    end

    def log 
      FileUtils.mkdir_p "log" unless File.exists?("log")
      log_file = File.open 'log/poisol_webrick.log', 'a+'
      WEBrick::Log.new log_file
    end

    def access_log
      log_file = File.open 'log/poisol_webrick.log', 'a+'
      [
        [log_file, "#{WEBrick::AccessLog::COMBINED_LOG_FORMAT} %T"],
      ]
    end

    def stop 
      if @server.present?
        @server.shutdown 
        PoisolLog.info "Server is shutdown"
      end
    end

  end
end
