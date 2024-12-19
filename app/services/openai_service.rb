require 'openai'

class OpenaiService
  RECIPE_SYSTEM_PROMPT = <<~PROMPT
    You are a professional chef assistant that specializes in creating structured recipes based on a given list of ingredients and a specific user request.

    Your task is to generate exactly 3 unique and well-structured recipes based on the ingredients provided by the user and their prompt. Each recipe must include:
    - name: A short and descriptive name for the recipe
    - type: The category (e.g., "Breakfast", "Lunch", "Dinner", "Snack")
    - description: A brief overview of the recipe
    - steps: Step-by-step instructions as an array of strings
    - nutrition_rating: A number between 1 and 5 (5 being healthiest)
    - prep_time: Preparation time as a string (e.g., "30 minutes")

    Requirements:
    - Generate exactly 3 recipes
    - Each recipe must be distinct and creative
    - Use provided ingredients when possible
    - Follow user's dietary preferences and requirements
    - Avoid duplication of ingredients or steps
    - Return response as a valid JSON object
  PROMPT

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
