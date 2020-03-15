module DomainCheck
    class Base < Grape::API
        mount DomainCheck::V1::Domains
    end
end