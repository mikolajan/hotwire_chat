class User < ApplicationRecord
  has_many :messages, -> { sorted }, dependent: :destroy

  scope :without_user, ->(user) { where.not(id: user) }

  validates :nickname, presence: true, uniqueness: true # email is validated by Devise

  before_validation :normalize_params, on: :create

  # Include default devise modules. Others available are:
  # :recoverable, :rememberable, :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable

  def author_of?(object)
    self == object.user
  end

  def room_title_with(user)
    return unless user&.persisted?

    [self, user].map(&:id).sort.join('_')
  end

  private

  def normalize_params
    self.email = email.downcase if email.present?
    self.nickname = nickname.downcase if nickname.present?
  end
end
