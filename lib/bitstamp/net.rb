module Bitstamp
  module Net

    def self.to_old_uri(path)
      return "https://www.bitstamp.net/api/#{path}/"
    end

    def self.to_uri(path)
      return "https://www.bitstamp.net/api/v2#{path}/"
    end

    def self.get(path, options={}, v2=true)
      unless v2
        RestClient.get(self.to_old_uri(path))
      else
        RestClient.get(self.to_uri(path))
      end
    end

    def self.post(path, options={}, v2=true)
      unless v2
        RestClient.post(self.to_old_uri(path), self.bitstamp_options(options))
      else
        RestClient.post(self.to_uri(path), self.bitstamp_options(options))
      end
    end

    def self.patch(path, options={}, v2=true)
      unless v2
        RestClient.put(self.to_old_uri(path), self.bitstamp_options(options))
      else
        RestClient.put(self.to_uri(path), self.bitstamp_options(options))
      end
    end

    def self.delete(path, options={}, v2=true)
      unless v2
        RestClient.delete(self.to_old_uri(path), self.bitstamp_options(options))
      else
        RestClient.delete(self.to_uri(path), self.bitstamp_options(options))
      end
    end

    def self.bitstamp_options(options={})
      if Bitstamp.configured?
        options[:key] = Bitstamp.key
        options[:nonce] = (Time.now.to_f*10000).to_i.to_s
        options[:signature] = HMAC::SHA256.hexdigest(Bitstamp.secret, options[:nonce]+Bitstamp.client_id.to_s+options[:key]).upcase
      end

      options
    end
  end
end
