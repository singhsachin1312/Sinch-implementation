class SinchService

  SEND_MSG_URL = "https://sms.api.sinch.com/xms/v1/#{Rails.application.secrets.sinch_service_plan_id}/batches"

  def self.send_message(recipient, msg)
    uri = URI.parse(SEND_MSG_URL)
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer #{Rails.application.secrets.sinch_api_token}"
    request.body = msg_request_params(recipient, msg)
    req_options = { use_ssl: uri.scheme == "https"}
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    raise(response.message) unless response.code.to_i == 201
    return true
  rescue Exception => e
    raise(e.message)
  end 

  def self.msg_request_params(recipient, msg)
    JSON.dump({
      "from" => "#{Rails.application.secrets.sinch_sender_id}",
      "to" => [
        "#{recipient.country_code}#{recipient.phone_number}"
      ],
      "body" => msg
    })
  end 
end   