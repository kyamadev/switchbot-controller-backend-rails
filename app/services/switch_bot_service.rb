require 'net/http'
require 'uri'
require 'json'
require 'openssl'

class SwitchBotService
  BASE_URL = 'https://api.switch-bot.com/v1.1'

  def initialize(user)
    @token = user.switchbot_token
    @secret = user.switchbot_secret
    @timestamp = (Time.now.to_f * 1000).to_i.to_s
    @sign = generate_signature
    @headers = {
      "Authorization" => @token,
      "t" => @timestamp,
      "sign" => @sign,
      "Content-Type" => "application/json"
    }
  end

  def get_devices
    uri = URI("#{BASE_URL}/devices")
    request = Net::HTTP::Get.new(uri)
    set_headers(request)

    send_request(uri, request)
  end

  def control_device(device_id, command, parameter = "default", command_type = "command")
    uri = URI("#{BASE_URL}/devices/#{device_id}/commands")
    request = Net::HTTP::Post.new(uri)
    set_headers(request)

    body = {
      command: command,
      parameter: parameter,
      commandType: command_type
    }.to_json
    request.body = body

    send_request(uri, request)
  end

  private

  def generate_signature
    data = "#{@token}#{@timestamp}"
    OpenSSL::HMAC.hexdigest('SHA256', @secret, data).upcase
  end

  def set_headers(request)
    @headers.each { |key, value| request[key] = value }
  end

  def send_request(uri, request)
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      response = http.request(request)
      JSON.parse(response.body)
    end
  rescue StandardError => e
    { error: e.message }
  end
end