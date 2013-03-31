module BackupDemon
  class Notifier
    def initialize(recepients)
      @recepients = [recepients].flatten
    end

    def mail(subject, &block)
      if block_given?
        msg = yield

        @recepients.each do |recepient|
          `echo #{msg} | mail -s "#{subject}" #{recepient}` 
        end
      end
    end

    def self.alert(subject, &block)
      notifier = new(BackupDemon.config.recepients)
      notifier.mail(subject, block)
    end
  end
end