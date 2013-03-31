$LOAD_PATH.unshift 'lib'
require 'backup_demon/version'

Gem::Specification.new do |s|
  s.name              = "backup_demon"
  s.version           = BackupDemon::Version
  s.summary           = "BackupDemon backs up to external drives"
  s.homepage          = "https://github.com/ryanfaerman/backup_demon"
  s.email             = ["ry@nwitty.com"]
  s.authors           = ["Ryan Faerman"]

  s.files         = `git ls-files`.split($/).reject{ |f| f =~ /^examples/ }
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  # s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  # s.extra_rdoc_files  = [ "LICENSE.txt", "CHANGELOG.md", "README.md", "CONTRIBUTING.md" ]
  # s.rdoc_options      = ["--charset=UTF-8"]

  s.add_dependency "thor",            "~> 0.18"

  s.description = %s{
    BackupDemon is a daemon for backing up directories to an external drive}
end
