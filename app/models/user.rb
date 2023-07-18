class User < ApplicationRecord
  validates :nickname, presence: true, uniqueness: true # email is validated by Devise

  before_validation :normalize_params, on: :create

  # Include default devise modules. Others available are:
  # :recoverable, :rememberable, :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable

  private

  def normalize_params
    self.email = email.downcase if email.present?
    self.nickname = nickname.downcase if nickname.present?
  end
end
