require 'openai'

class OpenaiService
  RECIPE_SYSTEM_PROMPT = <<~PROMPT
    You are a professional chef assistant that specializes in creating structured recipes based on a given list of ingredients and a specific user request.

    Your task is to generate exactly 3 unique and well-structured recipes based on the ingredients provided by the user and their prompt. Each recipe must include:
    - name: A short and descriptive name for the recipe
    - recipe_type: The category (e.g., "Breakfast", "Lunch", "Dinner", "Snack")
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

  def generate_image(recipe_name, recipe_description)
    begin
      response = @client.images.generate(
        parameters: {
          model: ENV.fetch('DALLE_MODEL', 'dall-e-3'),
          prompt: generate_image_prompt(recipe_name, recipe_description),
          n: 1,
          size: "1024x1024",
          quality: "standard",
          response_format: "b64_json"
        }
      )

      if response.dig("data", 0, "b64_json")
        save_image(response["data"][0]["b64_json"], recipe_name)
      else
        raise "No image data in response"
      end
    rescue OpenAI::Error => e
      Rails.logger.error "DALL-E API error: #{e.message}"
      use_placeholder_image(recipe_name)
    rescue StandardError => e
      Rails.logger.error "Image generation error: #{e.message}"
      use_placeholder_image(recipe_name)
    end
  end

  private

  def generate_image_prompt(name, description)
    "Professional food photography of #{name}. Shot from a 45-degree angle with soft natural lighting from the left. The dish is beautifully plated on a neutral ceramic plate against a light textured background. Shallow depth of field with the main elements in sharp focus. Garnished and styled with minimal, complementary props. #{description}. The photo has rich colors, subtle shadows, and a clean, modern aesthetic typical of high-end restaurant photography."
  end

  def save_image(base64_data, recipe_name)
    # Create uploads directory if it doesn't exist
    uploads_dir = Rails.root.join('public', 'uploads', 'recipes')
    FileUtils.mkdir_p(uploads_dir) unless Dir.exist?(uploads_dir)

    # Generate unique filename
    filename = "#{recipe_name.parameterize}-#{SecureRandom.hex(8)}.png"
    filepath = uploads_dir.join(filename)

    # Decode and save the image
    File.open(filepath, 'wb') do |file|
      file.write(Base64.decode64(base64_data))
    end

    # Return the relative path for database storage
    "/uploads/recipes/#{filename}"
  end

  def use_placeholder_image(recipe_name)
    # Copy placeholder image and return its path
    placeholder_source = Rails.root.join('app', 'assets', 'images', 'placeholder-recipe.png')
    filename = "#{recipe_name.parameterize}-placeholder.png"
    destination = Rails.root.join('public', 'uploads', 'recipes', filename)
    
    FileUtils.cp(placeholder_source, destination)
    "/uploads/recipes/#{filename}"
  end
end
