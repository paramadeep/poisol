class PoisolLog
  class << self

    def logger
      FileUtils.mkdir_p "log" unless File.exists?("log")
      @poisol_logger ||= Logger.new("log/poisol_stub.log")
      @poisol_logger.formatter = proc { |severity, datetime, progname, msg| "#{msg}\n" }
      @poisol_logger.level = Logger::INFO
      @poisol_logger
    end

    def error message
      logger.error "#{message}"
    end

    def info message
      logger.info "#{message}"
    end

    def warn message
      logger.warn "#{message}"
    end

    def debug message
      logger.debug "#{message}"
    end

  end
end
