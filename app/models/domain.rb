require 'net/http'
require 'openssl'

class Domain < ApplicationRecord
    include AASM

    @regular_domain = /\A([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}\z/

    validates :path, presence: true
    validates :path, uniqueness: { case_sensitive: false }
    validates_format_of :path, :with => @regular_domain


    aasm :column => 'status', whiny_transitions: false do
        state :not_ok, inital: true
        state :its_ok

        event :process do
            transitions :from => :not_ok, :to => :its_ok, :guard => [:valid_domain?, :without_errors?]
        end   
    end

    # проверка валидности домена
    def valid_domain?
        domain = self.path
        exist_domain = Domain.where(path: domain).first

        if exist_domain.nil? && (@regular_domain =~ domain).nil?
            self.error = "Connected error: already exists"
            return false
        end

        return true
    end

    # проверка ошибок SSL и ошибок подключения
    def without_errors?
        domain = self.path

        begin
            uri = URI::HTTPS.build(host: domain)  
            response = Net::HTTP.start(uri.host, uri.port, :use_ssl => true, :verify_mode => OpenSSL::SSL::VERIFY_PEER)
        rescue OpenSSL::SSL::SSLError => exception
            if exception.to_s.scan("has expired").empty?
                self.error = "SSL Error: " + exception.to_s.split(':')[1].strip
            else
                self.error = "Certificate has expired"
            end
            return false
        rescue => exception
            self.error = "Connected error: " + exception.to_s
            return false
        end

        cert = response.peer_cert
        not_expired?(cert)
    end

    # проверка срока сертификата
    def not_expired?(cert)
        two_weeks = 14 * 86400 # 14 * One day
        one_week = 7 * 86400
        weeks_left = ((cert.not_after - Time.now) / 86400 / 7)

        if weeks_left <= 0 
            self.error = "Certificate was expired"
            return false
        elsif weeks_left < 1
            self.error = "Left less then one week"
        elsif weeks_left < 2
            self.error = "Left less then two weeks"
        else 
            self.error = "No error"
        end

        return true
    end
end
