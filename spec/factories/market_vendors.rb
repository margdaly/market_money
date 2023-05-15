FactoryBot.define do
  factory :market_vendor do
    market { association :market }
    vendor { association :vendor }
  end
end
