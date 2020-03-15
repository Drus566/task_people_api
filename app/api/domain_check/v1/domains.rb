# frozen_string_literal: true

module DomainCheck
  module V1
    class Domains < Grape::API
      format :json

      resource :status do
        desc 'Return list of domains'
        get do
          domains = Domain.all
          present domains, with: DomainCheck::Entities::Domain
        end
      end

      resource :domain do
        desc 'Create a domain.'
        params do
          requires :domain, type: Hash do
            requires :path, type: String, desc: 'Path'
            # requires :status, type: Boolean, desc: 'Status'
          end
        end
        post do
          domain = Domain.new(params[:domain])
          if domain.save
            CheckWorker.perform_async(domain.id)
            present domain
          else
            status 400
            present domain.errors
          end
        end
      end
    end
  end
end
