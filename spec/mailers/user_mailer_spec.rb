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
      expect(mail.body.encoded).to match(@user.activation_token)
      expect(mail.body.encoded).to match CGI.escape(@user.email)
    end
  end
end

RSpec.describe UserMailer, type: :mailer do
  describe "password_reset" do

    let(:mail) { UserMailer.password_reset(@user) }
    before do
      @user = FactoryBot.create(:user)
      @user.reset_token = User.new_token 
      # これ必要！！　上のactivationの方はbefore_createでtoken生成してくれてたけどこっちはそうじゃないから
      # 作ってあげる必要あり
    end

    it "renders the headers" do
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("To reset your password click the link below:")
      expect(mail.body.encoded).to match(@user.reset_token)
      expect(mail.body.encoded).to match CGI.escape(@user.email)
      
    end
  end

end
