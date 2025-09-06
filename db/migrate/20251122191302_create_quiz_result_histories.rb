class CreateQuizResultHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :quiz_result_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :quiz, null: false, foreign_key: true
      t.integer :score
      t.integer :questions_count
      t.datetime :completed_at

      t.timestamps
    end
  end
end
