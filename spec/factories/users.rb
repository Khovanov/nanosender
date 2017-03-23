FactoryGirl.define do
  sequence :user_name do |n|
    "Username #{n}"
  end

  factory :user do
    name { generate :user_name }
  end
end
