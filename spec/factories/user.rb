FactoryBot.define do
  factory :user do
    nickname { Faker::Name.first_name }
    email    { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
