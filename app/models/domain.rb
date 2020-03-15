# frozen_string_literal: true

require 'net/http'
require 'openssl'

class Domain < ApplicationRecord
  include AASM

  @regular_domain = /\A([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}\z/

  validates :path, presence: true
  validates :path, uniqueness: { case_sensitive: false }
  validates_format_of :path, with: @regular_domain

  aasm column: 'status', whiny_transitions: false do
    state :not_ok, inital: true
    state :its_ok

    event :process do
      transitions from: :not_ok, to: :its_ok, guard: %i[valid_domain? without_errors?]
    end
  end

  def valid_domain?
    domain = path
    exist_domain = Domain.where(path: domain).first

    if exist_domain.nil? && (@regular_domain =~ domain).nil?
      self.error = 'Connected error: already exists'
      return false
    end

    true
  end

  def without_errors?
    domain = path

    begin
      uri = URI::HTTPS.build(host: domain)
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_PEER)
    rescue OpenSSL::SSL::SSLError => e
      self.error = if e.to_s.scan('has expired').empty?
                     'SSL Error: ' + e.to_s.split(':')[1].strip
                   else
                     'Certificate has expired'
                   end
      return false
    rescue StandardError => e
      self.error = 'Connected error: ' + e.to_s
      return false
    end

    cert = response.peer_cert
    not_expired?(cert)
  end

  def not_expired?(cert)
    weeks_left = ((cert.not_after - Time.now) / 86_400 / 7)

    if weeks_left <= 0
      self.error = 'Certificate was expired'
      return false
    elsif weeks_left < 1
      self.error = 'Left less then one week'
    elsif weeks_left < 2
      self.error = 'Left less then two weeks'
    else
      self.error = 'No error'
    end

    true
  end
end
