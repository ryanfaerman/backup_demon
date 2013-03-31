require 'fileutils'

module BackupDemon
  class Device
    attr_reader :device, :mounted, :mount_point
    def initialize(device)
      @device = device
      @mounted = false
      @previous = nil
    end

    def exists?
      File.exists?(@device)
    end

    def different?
      begin      
        @previous != File.stat(@device)
      rescue
        false
      end
    end

    def self.mounted
      raw_mount_list = `mount`
      mount_list = {}
      raw_mount_list.split("\n").each do |line|
        items = line.split(' ')
        mount_list[items[0]] = items[2]
      end
      mount_list.select { |k, v| k =~ /^\/.*/} # only real devices
    end

    def mount(mount_point)
      @mount_point = mount_point
      FileUtils.mkdir_p(@mount_point) unless File.exists?(@mount_point)
      `mount #{@device} #{@mount_point}`
      
      if mounted?
        @previous = File.stat(@device)
        true
      else
        false
      end
    end

    def mounted?
      Device.mounted.keys.include?(@device)
      true
    end

    def unmount
      `umount #{@device}`
    end

    def unmounted?
      !mounted?
      true
    end
  end
end