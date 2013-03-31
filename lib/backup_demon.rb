require 'backup_demon/sync'
require 'backup_demon/device'

module BackupDemon
  class Daemon
    def initialize(directories, device_path, mount_point = "/mnt/backuphdd")
      @directories = [directories].flatten
      @shutdown = nil
      @paused = nil
      @drive = Device.new(device_path)
      @mount_point = mount_point
    end

    def run(interval = 5.0)
      interval = Float(interval)
      procline 'waiting for drive...'

      puts "#{@drive.exists?} && #{@drive.different?} (#{@drive.exists? && @drive.different?})"
      # puts "#{@drive.previous.inspect} != #{@drive.current.inspect} || #{@drive.current.nil?}"
      if @drive.exists? && @drive.different?
        puts "working..."
        procline 'Found Drive'
        if @drive.mount(@mount_point)
          @directories.each do |source|
            procline "Backing up #{source}"
            Sync.start(source, @drive.mount_point)
          end
        end
      end

      Kernel.sleep(interval)
    end

    def run!(interval = 5.0)
      Process.daemon(true)
      loop do
        run(interval)
      end
    end

    def procline(string)
      $0 = "backup-demon: #{string}"
    end
  end

end


puts "hello!"
# BackupDemon::Daemon.new(['tmp/banana', 'tmp/jones'], 'tmp/device', 'tmp/mount/point').run!