require "ostruct"
require "backup_demon/core_ext/hash"

module BackupDemon
  class Config
    attr_accessor :options

    def initialize(options = {})
      @options = {
        daemon: false,
        interval: 5,
        pid: nil,
        device: "/dev/sdb1",
        mount: "/mnt/backuphdd",
        directories: ""
      }.merge!(options.symbolize_keys!)
    end

    def timeout
      @options[:timeout].to_f
    end

    def interval
      @options[:interval].to_f
    end

    def directories
      @options[:directories]
    end

    def method_missing(name)
      name = name.to_sym
      if @options.has_key?(name)
        @options[name]
      end
    end

  end
end
