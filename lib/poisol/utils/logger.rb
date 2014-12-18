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
      logger.error "#{message}\n"
    end

    def info message
      logger.info "#{message}\n"
    end

    def warn message
      logger.warn "#{message}\n"
    end

    def debug message
      logger.debug "#{message}\n"
    end

  end
end
