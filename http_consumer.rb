require 'yaml'
require 'WEBrick'
require 'JSON'
require './Utils'

def process
  configs = Utils.configs
  newline = "\n"
  client = Utils.client configs['onsUrl']
  while true
    date = Time.now.to_i * 1000
    signString = "#{configs['topic']}#{newline}#{configs['consumerID']}#{newline}#{date}"
    sign = Utils.calSignature signString, configs['secretKey'] 
    res = client.get "#{configs['path']}message/?topic=#{configs['topic']}&time=#{date}&num=32" do |req|
      req.headers['Signature'] = sign
      req.headers['AccessKey'] = configs['accessKey']
      req.headers['ConsumerID'] = configs['consumerID']
    end
    unless WEBrick::HTTPStatus.success?(res.status)
      puts "consumer message error, response content: #{res.body}"
      sleep 2
      next
    end
    messages = JSON.parse res.body
    if messages.empty?
      sleep 2
      next
    end
    messages.each do |msg|
      puts "msg content: #{msg.to_json}"
      del_message msg
    end
    sleep 2
  end
end

def del_message(msg)
  configs = Utils.configs
  newline = "\n"
  client = Utils.client configs['onsUrl']
  date = Time.now.to_i * 1000
  signString = "#{configs['topic']}#{newline}#{configs['consumerID']}#{newline}#{msg['msgHandle']}#{newline}#{date}"
  sign = Utils.calSignature signString, configs['secretKey']
  res = client.delete "#{configs['path']}message/?msgHandle=#{msg['msgHandle']}&topic=#{configs['topic']}&time=#{date}" do |req|
    req.headers['Signature'] = sign
    req.headers['AccessKey'] = configs['accessKey']
    req.headers['ConsumerID'] = configs['consumerID']
  end
  if WEBrick::HTTPStatus.success?(res.status)
    puts "delete massage: #{msg.to_json}"
  else
    puts "delete massge error: #{res.body}"
  end
end
process()