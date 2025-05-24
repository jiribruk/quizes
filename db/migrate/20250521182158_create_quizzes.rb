# frozen_string_literal: true

class CreateQuizzes < ActiveRecord::Migration[7.1]
  def change
    create_table :quizzes do |t|
      t.string :name, null: false
      t.string :category
      t.integer :score, default: 0

      t.timestamps
    end
  end
end
