# frozen_string_literal: true

class CheckWorker
  include Sidekiq::Worker

  def perform(domain_id)
    domain = Domain.find(domain_id)
    domain.status = 'not_ok'
    domain.process
    domain.save
  end
end
