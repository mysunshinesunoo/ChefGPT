require 'openai'
require 'json-schema'

class OpenaiService
  include Prompts::RecipePrompts

  def initialize
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
  end

  def generate_recipe(prompt, ingredients = [])
    begin
      messages = [
        { 
          role: "system", 
          content: RECIPE_SYSTEM_PROMPT
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
          model: ENV.fetch('OPENAI_MODEL', 'gpt-3.5-turbo'),
          response_format: { type: "json_object" },
          temperature: 0.7
        }
      )

      if response.dig("choices", 0, "message", "content")
        json_response = JSON.parse(response["choices"][0]["message"]["content"])
        validate_response!(json_response)
        json_response
      else
        raise "No content in response"
      end
    rescue OpenAI::Error => e
      Rails.logger.error "OpenAI API error: #{e.message}"
      raise "Failed to generate recipe: #{e.message}"
    rescue JSON::ParserError => e
      Rails.logger.error "JSON parsing error: #{e.message}"
      raise "Failed to parse recipe response"
    rescue JSON::Schema::ValidationError => e
      Rails.logger.error "Schema validation error: #{e.message}"
      raise "Invalid recipe format received"
    rescue StandardError => e
      Rails.logger.error "Unexpected error: #{e.message}"
      raise "An unexpected error occurred: #{e.message}"
    end
  end

  private

  def validate_response!(response)
    JSON::Validator.validate!(RECIPE_JSON_SCHEMA, response)
  end
end
