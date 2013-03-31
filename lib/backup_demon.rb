require 'backup_demon/sync'
require 'backup_demon/device'
require 'backup_demon/daemon'
require 'backup_demon/config'
require 'backup_demon/notifier'

module BackupDemon

  def self.config=(options = {})
    @config = Config.new(options)
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield config
  end
end