class CreateAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :answers do |t|

      t.string :text, null: false
      t.boolean :correct, default: false

      t.belongs_to :question

      t.timestamps
    end
  end
end
