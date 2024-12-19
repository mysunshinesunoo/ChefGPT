module Prompts
  module RecipePrompts
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

    RECIPE_JSON_SCHEMA = {
      type: "object",
      properties: {
        recipes: {
          type: "array",
          items: {
            type: "object",
            properties: {
              name: { type: "string" },
              type: { type: "string" },
              description: { type: "string" },
              steps: { 
                type: "array", 
                items: { type: "string" }
              },
              nutrition_rating: { type: "number" },
              prep_time: { type: "string" }
            },
            required: ["name", "type", "description", "steps", "nutrition_rating", "prep_time"],
            additionalProperties: false
          }
        }
      },
      required: ["recipes"],
      additionalProperties: false
    }
  end
end 