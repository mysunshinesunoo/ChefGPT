require 'openai'

class OpenaiService
  def initialize
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
  end

  def generate_recipe(prompt, ingredients = [])
    begin
      messages = [
        { 
          role: "system", 
          content: "You are a professional chef assistant. Return your response as a JSON object with a 'recipes' array containing exactly 3 recipes. Each recipe should have: 'name', 'type', 'description', 'steps' (array), 'nutrition_rating' (1-5), 'prep_time', and 'image' (empty string)."
        },
        {
          role: "user",
          content: ingredients.any? ? 
            "I have these ingredients: #{ingredients.join(', ')}. #{prompt}" :
            prompt
        }
      ]

      response = @client.chat(
        parameters: {
          messages: messages,
          model: ENV.fetch('OPENAI_MODEL', 'gpt-4o-mini'),
          response_format: { type: "json_object" },
          temperature: 0.7
        }
      )

      if response.dig("choices", 0, "message", "content")
        JSON.parse(response["choices"][0]["message"]["content"])
      else
        raise "No content in response"
      end
    rescue OpenAI::Error => e
      Rails.logger.error "OpenAI API error: #{e.message}"
      raise "Failed to generate recipe: #{e.message}"
    rescue JSON::ParserError => e
      Rails.logger.error "JSON parsing error: #{e.message}"
      raise "Failed to parse recipe response"
    rescue StandardError => e
      Rails.logger.error "Unexpected error: #{e.message}"
      raise "An unexpected error occurred: #{e.message}"
    end
  end
end
