class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|

      t.string :text, null: false

      t.belongs_to :quiz

      t.timestamps
    end
  end
end
