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
    @other_user= FactoryBot.create(:user)
   
  end
    it "unsuccessful edit" do
      log_in(@user)
      visit edit_user_path(@user)
      fill_in 'Name', with:"AAA"
      fill_in 'Email', with:"aaa@111.com"
      fill_in 'Password', with: "abcdef"
      fill_in 'Password confirmation', with: "fbaxfe"
      find('input[name="commit"]').click
      expect(has_css?('.alert-danger')).to be_truthy
 
    end

    it "successful edit" do
      log_in(@user)
      visit edit_user_path(@user)
      fill_in 'Name', with:"AAA"
      fill_in 'Email', with:"aaa@111.com"
      fill_in 'Password', with: "abcdef"
      fill_in 'Password confirmation', with: "abcdef"
      find('input[name="commit"]').click
      expect(current_path).to eq(user_path(@user))
      expect(page).to have_content'Profile updated'

      @user.reload
      expect(@user.name).to eq("AAA")
      expect(@user.email).to eq("aaa@111.com")

    end

    it "should redirect edit when not logged in" do
      visit edit_user_path(@user)
      expect(current_path).to eq(login_path)
    end

    # ログインしていないupdateのテストはrequest specで書く（下）
    it 'should redirect edit when logged in as wrong user' do
      log_in(@user)
      visit edit_user_path(@other_user)
      expect(current_path).to eq(root_path)


    end

    it "successful edit with friendly forwarding" do

      visit edit_user_path(@user)
      log_in(@user)
      expect(current_path).to eq(edit_user_path(@user))
      fill_in 'Name', with:"BBB"
      fill_in 'Email', with:"abc@111.com"
      find('input[name="commit"]').click
      expect(current_path).to eq(user_path(@user))
      expect(page).to have_content'Profile updated'
    end

    it "should redirect index when not logged in" do
      visit users_path
      expect(current_path).to eq(login_path)
    end


end


RSpec.describe "Index 大量のuser", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @other_user= FactoryBot.create(:user)
    @users=FactoryBot.create_list(:user, 100)
  end

  
  it 'index including pagination' do
    log_in(@user)
    visit users_path
    User.paginate(page: 1).each do |user|
      expect(page).to have_link href: user_path(user)
      expect(page).to have_content(user.name)
    end
  end


end






RSpec.describe "Users", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @other_user= FactoryBot.create(:user)
  end

  it 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: { name: @user.name,
      email: @user.email } }
    expect(response).to redirect_to login_path
  end

  it "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
      email: @user.email } }
    expect(response).to redirect_to root_path


  end

  






end

  



