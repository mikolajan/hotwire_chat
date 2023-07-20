class Room < ApplicationRecord
  has_many :messages, -> { sorted }, dependent: :destroy

  validates :title, presence: true
end
