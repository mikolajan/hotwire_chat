class Room < ApplicationRecord
  has_many :messages, -> { sorted }, dependent: :destroy

  enum room_type: {users: 0, user: 1 }, _suffix: :type

  validates :title, presence: true
end
