FactoryBot.define do
  factory :bulk_discount do
    quantity { 1 }
    percent { 1 }
    merchant { nil }
  end
end
