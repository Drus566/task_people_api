class CheckAllWorker
    include Sidekiq::Worker

    def perform
        domains = Domain.all
        domains.each do |domain| 
            domain.status = "not_ok"
            domain.process
            domain.save
        end
    end
end
  