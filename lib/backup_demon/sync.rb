 module BackupDemon
  class Sync
    def self.start(source, destination)
      puts "Syncing #{source} to #{destination}"
      `rsync -avz #{source} #{destination}`
    end
  end
end