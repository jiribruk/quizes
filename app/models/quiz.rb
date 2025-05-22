# Quiz represents a quiz entity.
#
# @see https://guides.rubyonrails.org/active_record_basics.html
class Quiz < ApplicationRecord
  has_many :questions, inverse_of: :quiz, dependent: :destroy

  validates :name, presence: true

end
