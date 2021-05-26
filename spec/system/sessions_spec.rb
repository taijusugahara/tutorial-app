require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  it 'should get new' do
    visit login_path
    expect(current_path).to eq(login_path)
  end

  it "login with invalid information" do
    visit login_path
    fill_in 'Email', with: ""
    fill_in 'Password', with: ""
  
      find('input[name="commit"]').click
    
    expect(page).to have_content("Invalid email/password combination")
    visit help_path
    expect(page).not_to have_content("Invalid email/password combination")
  end

  it "login with valid information" do
    visit login_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    find('input[name="commit"]').click
    expect(current_path).to eq(user_path(@user))
    find(".dropdown-toggle").click
    # ドロップダウンをクリック　クラス名
    expect(page).to have_link href: logout_path
    expect(page).to have_link href: user_path(@user)
    expect(page).not_to have_link href: login_path
  end

  it "login with valid email/invalid password" do
    visit login_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: "abcdef"
  
      find('input[name="commit"]').click
    
    expect(page).to have_content("Invalid email/password combination")
    visit help_path
    expect(page).not_to have_content("Invalid email/password combination")
  end

  it "login with valid information followed by logout" do
    visit login_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    find('input[name="commit"]').click
    expect(current_path).to eq(user_path(@user))
    find(".dropdown-toggle").click
   
    expect(page).to have_link href: logout_path
    click_link 'Log out'
    # リンクをクリックする

    # click_link 'Log out'
    # 複数のタブでログインしていた時でのログアウト　これはわからないな。画面にLog outはもうないからこれでエラーが出るのはわかる。

    expect(current_path).to eq(root_path)
    expect(page).to have_link href: login_path

    
  end
  it 'log_in remember' do
    log_in(@user)
  end

  
end


RSpec.describe "Sessions", type: :request do
  before do
    @user = FactoryBot.create(:user)
  end
  # let(:user) { FactoryBot.create(:user) }

  it '二つのタブでログアウト' do
    delete logout_path
    expect(response).to redirect_to root_path
    expect(is_login?).to be_falsy

  end

  it 'login with remembering' do 
    log_in_as(@user, remember:'1')
    expect(cookies[:remember_token]).not_to eq nil
  end

  it "login without remembering" do
    log_in_as(@user, remember:'0')
    expect(cookies[:remember_token]).to eq nil
  end

end

RSpec.describe SessionsHelper, type: :helper do
              #  SessionsHelperについてテストしますよ　typeはhelperで
  
  before do
    @user = FactoryBot.create(:user)
    remember(@user)
  end
  

  it 'current_user returns right user when session is nil' do
    expect(current_user).to eq @user
    expect(is_login?).to be_truthy
  end

  it "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    expect(current_user).not_to eq @user
    expect(is_login?).to be_falsy
  end

end

