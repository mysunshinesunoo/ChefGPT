require 'openai'

class OpenaiService
  def initialize
    @client = OpenAI::Client.new(api_key: ENV['OPENAI_API_KEY'])
  end

  
end
