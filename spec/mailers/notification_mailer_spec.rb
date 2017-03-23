require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "job_failed" do
    let(:mail) { NotificationMailer.job_failed "Viber", "Exception text" }

    it "renders the headers" do
      expect(mail.subject).to eq("Viber Exception")
      expect(mail.to).to eq(['admin@example.com'])
      expect(mail.from).to eq(['nanosender@example.com'])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Exception text")
    end
  end
end
