require 'rails_helper'

RSpec.describe SendMessageJob, type: :job do
  let(:user) { create :user }

  BaseMessenger::MESSENGERS.each do |attr|
    it "should send message to #{attr}" do
      expect(messenger_class(attr))
        .to receive(:new)
        .with(user_id: user.id, body: "Some text")
        .and_call_original
      SendMessageJob.perform_now(user_id: user.id, messenger: attr, body: "Some text")
    end
  end

  def messenger_class(name)
    "#{name.downcase.camelize}Messenger".constantize
  end
end
