# Question represents a question in a quiz.
#
# @see https://guides.rubyonrails.org/active_record_basics.html
class Question < ApplicationRecord
  has_many :answers, inverse_of: :question, dependent: :destroy

  belongs_to :quiz, inverse_of: :questions, optional: false

  validates :text, presence: true

end
