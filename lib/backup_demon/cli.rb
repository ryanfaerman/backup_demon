require 'thor'
require 'backup_demon'
require 'yaml'

module BackupDemon
  class CLI < Thor

    class_option :config,    :aliases => ["-c"], :type => :string

    desc "start", "run the BackupDemon Daemon"
    option :daemon, aliases: ["-d"], type: :boolean, default: false
    option :interval, aliases: ["-i"], type: :numeric
    option :pid, aliases: ["-p"], type: :string
    option :device, aliases: ["-s"], type: :string
    option :mount, aliases: ["-m"], type: :string
    option :directories, type: :string

    def start(directories = nil)
      load_config
      
      directories = directories.to_s.split(',').map(&:strip) unless directories.nil?

      daemon = BackupDemon::Daemon.new(
        directories || BackupDemon.config.directories, 
        BackupDemon.config.device, 
        BackupDemon.config.mount
      )

      if BackupDemon.config.daemon
        Process.daemon(true)
      end

      if BackupDemon.config.pid
        File.open(BackupDemon.config.pid, 'w') { |f| f << daemon.pid }
      end

      daemon.run!(BackupDemon.config.interval)
    end

    desc "stop", "stop the BackupDemon Daemon"
    option :pid, aliases: ["-p"], type: :string
    def stop(pid = nil)
      load_config
      pidfile = BackupDemon.config.pid

      if pidfile && File.exists?(pidfile)
        File.foreach(pidfile) do |pid|
          begin
            Process.kill("KILL", pid.to_i)
          rescue
            puts "Nothing to stop"
          end
        end
      end
    end

    protected
      def load_config
        opts = {}
        if options[:config]
          opts = YAML.load_file(File.expand_path(options[:config]))
        end

        BackupDemon.config = opts.merge!(options)
      end

  end
end