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

# Seed for quiz about the movie Babovřesky
quiz = Quiz.create!(name: "Kvíz o filmu Babovřesky")

questions_data = [
  {
    text: "Kdo je režisérem filmu Babovřesky?",
    answers_attributes: [
      { text: "Zdeněk Troška", correct: true },
      { text: "Jan Hřebejk", correct: false },
      { text: "Jiří Menzel", correct: false },
    ],
  },
  {
    text: "V jakém roce měl film Babovřesky premiéru?",
    answers_attributes: [
      { text: "2013", correct: true },
      { text: "2010", correct: false },
      { text: "2015", correct: false },
    ],
  },
  {
    text: "Která postava je farářem v Babovřeskách?",
    answers_attributes: [
      { text: "Petr", correct: true },
      { text: "Karel", correct: false },
      { text: "Marek", correct: false },
    ],
  },
  {
    text: "Jaký žánr nejlépe vystihuje film Babovřesky?",
    answers_attributes: [
      { text: "Komedie", correct: true },
      { text: "Drama", correct: false },
      { text: "Horor", correct: false },
    ],
  },
  {
    text: "Kde se film Babovřesky převážně natáčel?",
    answers_attributes: [
      { text: "Jižní Čechy", correct: true },
      { text: "Praha", correct: false },
      { text: "Krkonoše", correct: false },
    ],
  },
]

questions_data.each do |question|
  quiz.questions.create!(question)
end