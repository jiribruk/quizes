class CreateQuizzes < ActiveRecord::Migration[7.1]
  def change
    create_table :quizzes do |t|

      t.string :name, null: false
      t.integer :score, default: 0

      t.timestamps
    end
  end
end
