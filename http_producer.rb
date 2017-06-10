require 'yaml'
require 'WEBrick'
require './Utils'

def process
  configs = Utils.configs
  newline = "\n"
  client = Utils.client configs['onsUrl']
  content = "中文".encode Encoding.find("UTF-8")
  puts "#{content}------"
  10.times do 
    date = Time.now.to_i * 1000
    signString = "#{configs['topic']}#{newline}#{configs['producerID']}#{newline}#{Digest::MD5.hexdigest content}#{newline}#{date}"
    sign = Utils.calSignature signString, configs['secretKey'] 
    res = client.post do |req|
      req.url "#{configs['path']}message/?topic=#{configs['topic']}&time=#{date}&num=32"
      req.headers['Signature'] = sign
      req.headers['AccessKey'] = configs['accessKey']
      req.headers['ProducerID'] = configs['producerID']
      req.headers['Content-Type'] = "text/html;charset=UTF-8"
      req.body = content
    end
    if WEBrick::HTTPStatus.success?(res.status)
      puts "send message success, response content: #{res.body}"
    else
      puts "send message error, response content: #{res.body}"
    end 
  end
end

process()