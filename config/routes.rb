require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount DomainCheck::Base => '/'
  mount Sidekiq::Web => '/sidekiq'
end
