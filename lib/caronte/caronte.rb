require 'resolv'
require 'caronte/tlds'

module Caronte
  class Resolver
    def self.resolver
      @@resolver ||= Resolv::DNS.new
    end

    def self.is_address?(name)
      !(name =~ /(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/).nil?
    end

    def self.check(name)
      # reverse ip address
      if is_address? name
        name = name.split(".").reverse.join(".")
      # remove www.
      else
        tld = SpamKiller::TLDS.select {|v| name =~ /#{v}$/}
        tld_size = tld.size > 0 ? tld.last.split(".").size : 1
        name = name.split(".")[-1-(tld_size)..-1].join(".")
      end

      records = self.resolver.getresources( "#{name}.zen.spamhaus.org", Resolv::DNS::Resource::IN::A )
      code    = nil
      list    = nil

      unless records.empty?
        code = records.first.address.to_s.split('.').last.to_i
        list = case code
               when 10..11
                 'Policy Block List'
               when 4..7
                 'Exploits Block List'
               when 3
                 'CSS Component'
               when 2
                 'Block List'
               else
                 'Unknown List'
               end
      end
      
      code.nil? ? nil : [ code, list ]
    end
  end
end
