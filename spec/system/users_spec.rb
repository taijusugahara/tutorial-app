require 'rails_helper'
# include SessionsHelper

RSpec.describe "Users", type: :system do

  

  it 'should get new' do
    visit signup_path
    expect(current_path).to eq (signup_path)
  end

  context 'Signup' do
    it "invalid signup information" do
      visit signup_path
      fill_in 'Name', with:""
      fill_in 'Email', with:"111@111.com"
      fill_in 'Password', with: "101010"
      fill_in 'Password confirmation', with: "101010"
      expect do
        find('input[name="commit"]').click
      end.to change { User.count }.by(0)

      expect(page).to have_content('Sign up')
      # これは違う
      # expect(current_path).to eq(users_path)

      expect(has_css?('.alert-danger')).to be_truthy
      
    end

    it "valid signup information" do
      visit signup_path
      fill_in 'Name', with:"111"
      fill_in 'Email', with:"111@111.com"
      fill_in 'Password', with: "101010"
      fill_in 'Password confirmation', with: "101010"
      expect do
        find('input[name="commit"]').click
      end.to change { User.count }.by(1)

      expect(has_css?('.user_info')).to be_truthy
      # showページにあるCSS これなくてもいいよ

      expect(page).to have_content'Welcome to the Sample App!'
      # flash

      # ログインしているかどうかは
      # ログアウト等があることで証明できると思う
      find(".dropdown-toggle").click
    # ドロップダウンをクリック　クラス名
      expect(page).to have_link href: logout_path
      # expect(page).to have_link href: user_path(@user) これはだめか
      expect(page).not_to have_link href: login_path
      

      
    end
  end
end
RSpec.describe "Users", type: :system do
  before do
    @user = FactoryBot.create(:user)
   
  end
    it "unsuccessful edit" do
      visit edit_user_path(@user)
      fill_in 'Name', with:"AAA"
      fill_in 'Email', with:"aaa@111.com"
      fill_in 'Password', with: "abcdef"
      fill_in 'Password confirmation', with: "fbaxfe"
      find('input[name="commit"]').click
      expect(has_css?('.alert-danger')).to be_truthy
      


    end


end

  



