FactoryBot.define do
  factory :message do
    body { Faker::Markdown.emphasis }
  end
end
