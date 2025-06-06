# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'json'

seed_files = Dir[Rails.root.join('db', 'seeds', '**', '*.json')]

seed_files.each do |file_path|
  data = JSON.parse(File.read(file_path))
  quiz = Quiz.create!(name: data['name'], category: data['category'])
  data['questions'].each do |question|
    quiz.questions.create!(question)
  end
end
