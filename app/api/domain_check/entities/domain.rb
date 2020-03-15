# frozen_string_literal: true

module DomainCheck
  module Entities
    class Domain < Grape::Entity
      expose :id
      expose :path
      expose :status
      expose :error
    end
  end
end
