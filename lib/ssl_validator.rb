require 'net/http'
require 'openssl'
require 'active_support/all'

domain_name = "expired.badssl.com"

begin
    uri = URI::HTTPS.build(host: domain_name)  
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => true, :verify_mode => OpenSSL::SSL::VERIFY_PEER)
rescue OpenSSL::SSL::SSLError => exception
    if exception.to_s.scan("has expired").empty?
        error = "SSL Error: " + exception.to_s.split(':')[1].strip
    else
        error = "Certificate has expired"
    end
rescue => exception
    error = "Connected error: " + exception.to_s
end

puts error if error
return unless response
puts "Its ok"

# puts "Its ok"
# # cert = response.peer_cert
# # puts "Address: " + response.address
# puts "Verify mode SSL=1 NoSSL=0: " + response.verify_mode.to_s
# # puts "Port: " + response.port.to_s
# # puts "Open timeout: " + response.open_timeout.to_s
# # puts "Max retries: " + response.max_retries.to_s
# # puts "Active?: " + response.active?.to_s
# puts "Use ssl?: " + response.use_ssl?.to_s
# puts "Not after: " + response.peer_cert.not_after.to_s
# # puts "Ssl timeout: " + response.ssl_timeout.to_s
# # puts "Ssl versions: " + response.ssl_version.to_s
# # puts "Proxy?: " + response.proxy?.to_s
# # puts "Peer cert algorithm: " + response.peer_cert.signature_algorithm
# # puts response.read_timeout
# # puts response.write_timeout

# puts "Not before: " + response.peer_cert.not_before.to_s
# puts "Issuer: " + response.peer_cert.issuer.to_s
# puts "Subject: " + response.peer_cert.subject.to_s
# puts "Version: " + response.peer_cert.version.to_s
# puts "Serial: " + response.peer_cert.serial.to_s
# puts "Public key: " + response.peer_cert.public_key.to_s 
# # puts "Verify: #{response.peer_cert.verify(response.peer_cert.public_key)}"

# def expiry(response)
#     two_weeks = 14 * 86400 # 14 * One Day
#     one_week = 7 * 86400
#     weeks_left = (response.peer_cert.not_after - Time.now).weeks.to_s

#     if weeks_left <= 0 
#         puts "Certificate was expired"
#     elsif weeks_left < 1
#         puts "Left less then one week"
#     elsif weeks_left < 2
#         puts "Left less then two weeks"
#     end

#     puts "Its ok"
# end

# puts expiry(response)
# two_weeks = 14 * 86400 # 14 * One Day

# puts (response.peer_cert.not_after - Time.now)/ 86400 / 7
# puts (response.peer_cert.not_after - Time.now) / 86400
# puts Time.now + two_weeks > response.peer_cert.not_after
# store = OpenSSL::X509::Store.new
# store.set_default_paths
# puts store.verify(response.peer_cert)











# Certificate
## !
## revoked.badssl.com
## pinning-test.badssl.com
## sha1-intermediate.badssl.com
## ?
## no-common-name.badssl.com
## no-subject.badssl.com
## rsa8192.badssl.com

# Client Sertificate
## !
## client-cert-missing.badssl.com

# Mix content
## !
## mixed-script.badssl.com
## very.badssl.com

# Http
## ! 

# Cipher Suite
## first
## !
## mozilla-old.badssl.com
## ?
## mozilla-intermediate.badssl.com

# Key Exchange
## ! 
## dh1024.badssl.com
## ?
## dh2048.badssl.com

## dh-small-subgroup.badssl.com
## dh-composite.badssl.com

## .
## static-rsa.badssl.com

# Protocol
## tls-v1-0.badssl.com:1010 
## all

# Certificate Transparency
## !
## no-sct.badssl.com

# UI
## .
## all