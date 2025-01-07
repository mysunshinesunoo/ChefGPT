# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Use your existing user
user = User.find_by(email: 'arstingabrelreano@gmail.com') # Replace with your email

if user.nil?
  puts "Error: User not found! Please make sure you're using the correct email."
  exit
end

# Common cooking ingredients with quantities
ingredients = [
  { name: 'chicken breast', quantity: 2 },
  { name: 'rice', quantity: 3 },
  { name: 'carrots', quantity: 4 },
  { name: 'onions', quantity: 2 },
  { name: 'garlic', quantity: 5 },
  { name: 'tomatoes', quantity: 4 },
  { name: 'potatoes', quantity: 3 },
  { name: 'olive oil', quantity: 1 },
  { name: 'salt', quantity: 1 },
  { name: 'black pepper', quantity: 1 },
  { name: 'eggs', quantity: 12 },
  { name: 'milk', quantity: 1 },
  { name: 'butter', quantity: 1 },
  { name: 'flour', quantity: 2 },
  { name: 'sugar', quantity: 1 }
]

# Create ingredients for your user
ingredients.each do |ingredient_data|
  user.ingredients.find_or_create_by!(name: ingredient_data[:name]) do |ingredient|
    ingredient.quantity = ingredient_data[:quantity]
  end
end

puts "Seeded #{ingredients.count} ingredients for #{user.email}"
