require 'date'

module BackupDemon
  class Daemon
    def initialize(directories, device_path, mount_point = "/mnt/backuphdd")
      @directories = [directories].flatten
      @drive = Device.new(device_path)
      @mount_point = mount_point
    end

    def run(interval = 5.0)
      interval = Float(interval)
      procline 'waiting for drive...'

      if @drive.exists? && @drive.different?
        procline 'Found Drive'
        
        Notifier.alert("Starting Backup") do
          "Starting Backup on #{Date.today}"
        end

        if @drive.mount(@mount_point)
          @directories.each do |source|
            procline "Backing up #{source}"
            Sync.start(source, @drive.mount_point)
          end
          @drive.ummount

          Notifier.alert("Backup Complete") do
            "Backup Complete on #{Date.today}"
          end
        else
          Notifier.alert("Backup Error") do
            "Unable to mount the backup disk."
          end
        end   
      end

      Kernel.sleep(interval)
    end

    def run!(interval = 5.0)
      loop do
        run(interval)
      end
    end

    def procline(string)
      $0 = "backup_demon: #{string}"
    end

    def pid
      @pid ||= Process.pid
    end
  end
end