require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:mail) { UserMailer.account_activation(@user) }
    before do
      @user = FactoryBot.create(:user)
      # mail = UserMailer.account_activation(@user)
    end

    it "renders the headers" do
      expect(mail.subject).to eq("Account activation")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Welcome to the Sample App! Click on the link below to activate your account")
      expect(mail.body.encoded).to match(@user.name)
    end
  end

  # describe "password_reset" do
  #   let(:mail) { UserMailer.password_reset }

  #   it "renders the headers" do
  #     expect(mail.subject).to eq("Password reset")
  #     expect(mail.to).to eq(["to@example.org"])
  #     expect(mail.from).to eq(["from@example.com"])
  #   end

  #   it "renders the body" do
  #     expect(mail.body.encoded).to match("Hi")
  #   end
  # end

end
