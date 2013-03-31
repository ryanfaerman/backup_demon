# Backup-Demon

Basically, a simple daemon that watches for a device to come around; then it mounts it, rsyncs it, and unmounts it.

To make things interesting, it won't keep backing up to the same drive, expecting you to swap the drive every time you want a new backup.

## Installing

    gem install backup_demon

That will give you the command `backup_demon` and get you rolling.
