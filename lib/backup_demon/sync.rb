 module BackupDemon
  class Sync
    def self.start(source, destination)
      puts "Syncing #{source} to #{destination}"
      sleep 2
    end
  end
end