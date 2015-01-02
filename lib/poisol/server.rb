module Server
  extend self

  def start port
    require 'webrick'
    @server =  WEBrick::HTTPServer.new :Port => port, :Logger => log, :AccessLog => access_log
    @port = port
    attach_shutdown
    attach_request_handling
    Thread.new{@server.start}
    PoisolLog.info "Server Started as http://localhost:#{port}"
  end

  def base_url
    "http://localhost:#{@port}"
  end

  def attach_request_handling
    @server.mount_proc '/' do |req, res|
      stub_response = ResponseMapper.map(req)
      res.status = stub_response.status
      res.body = stub_response.body.to_json
      res.content_type = 'application/json'
    end
  end

  def attach_shutdown 
    trap 'INT' do @server.shutdown end
  end

  def log 
    log_file = File.open 'log/poisol_webrick.log', 'a+'
    WEBrick::Log.new log_file
  end

  def access_log
    log_file = File.open 'log/poisol_webrick.log', 'a+'
    [
      [log_file, WEBrick::AccessLog::COMBINED_LOG_FORMAT],
    ]
  end

  def stop 
    if @server.present?
      @server.shutdown 
      PoisolLog.info "Server is shutdown"
    end
  end

end
