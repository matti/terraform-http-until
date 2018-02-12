require 'json'
require 'net/http'

class String
  def any?
    !self.empty?
  end
end

params = JSON.parse(STDIN.read)
uri = URI(params["uri"])
tries = 0

loop do
  tries = tries + 1
  response = Net::HTTP.get_response(uri)

  code_satisfied = if params["code_must_equal"].any?
    response.code == params["code_must_equal"]
  end

  body_satisfied = if params["body_must_include"].any?
    response.body.include?(params["body_must_include"])
  end

  satisfied = if params["code_must_equal"].any? && params["body_must_include"].any?
    true if code_satisfied && body_satisfied
  elsif params["code_must_equal"].any?
    true if code_satisfied
  elsif params["body_must_include"].any?
    true if body_satisfied
  else
    STDERR.puts "No exit condition specified, would run forever."
    exit 1
  end

  if satisfied
    result = {
      body: response.body,
      code: response.code,
      tries: tries.to_s,
      body_did_satisfy: body_satisfied.to_s,
      code_did_satisfy: code_satisfied.to_s
    }

    puts result.to_json
    break
  end

  if params["max_tries"].any? && params["max_tries"].to_i == tries
    STDERR.puts "max_tries (#{params["max_tries"]}) reached"
    exit 1
  end

  if params["interval"].any?
    sleep params["interval"].to_i
  else
    sleep 1
  end
end
