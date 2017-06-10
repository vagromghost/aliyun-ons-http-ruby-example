require 'Base64'
require 'OpenSSL'
require 'Faraday'

module Utils

  def self.calSignature(signString, sk)
    Base64.strict_encode64 OpenSSL::HMAC.digest('sha1', sk, signString)
  end

  def self.configs
    YAML.load File.open("config.yml")
  end

  def self.client(url)
    conn = Faraday.new(url: url) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end
  end
end