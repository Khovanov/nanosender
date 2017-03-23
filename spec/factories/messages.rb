FactoryGirl.define do
  factory :message do
    user_id  { create(:user).id }
    messenger "AnyMessenger"
    body "Some message"
  end

  factory :invalid_message, class: 'Message'  do
    user_id nil
    messenger nil
    body nil
  end
end
