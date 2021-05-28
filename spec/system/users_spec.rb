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

      # expect(has_css?('.user_info')).to be_truthy
      # showページにあるCSS これなくてもいいよ
      # アカウント有効かのところで、rootに行くように変更になったからもういらない
      expect(current_path).to eq(root_path)
      # expect(page).to have_content'Welcome to the Sample App!'
      # flashメッセージもアカウント有効化で変わったので変更

      expect(page).to have_content'Please check your email to activate your account.'
      # flash

    #  ＊＊＊＊＊以下のコードもアカウント有効化によりまだログインしていないので不要＊＊＊＊＊＊＊＊

      # ログインしているかどうかは
      # ログアウト等があることで証明できると思う
      # find(".dropdown-toggle").click
    # ドロップダウンをクリック　クラス名
      # expect(page).to have_link href: logout_path
                   # expect(page).to have_link href: user_path(@user) これはだめか
      # expect(page).not_to have_link href: login_path
      

      
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

  it 'should not allow the admin attribute to be edited via the web' do
    log_in_as(@other_user)
    patch user_path(@other_user), params: {
      user: { password:              "password",
              password_confirmation: "password",
              admin: true } }
    expect(@other_user.admin?).to be_falsy
      

  end


end

RSpec.describe "Admin", type: :request do
  before do
    @user = FactoryBot.create(:user,:admin)
    @other_user= FactoryBot.create(:user)
  end

  it "should redirect destroy when not logged in" do
    
    expect do
      delete user_path(@other_user)
    end.to change { User.count }.by(0)
    expect(response).to redirect_to login_url
  end

  it 'should redirect destroy when logged in as a non-admin' do
    log_in_as(@other_user)
    expect do
       delete user_path(@user)
    end.to change { User.count }.by(0)
    expect(response).to redirect_to root_path
  end


  it "index as admin including pagination and delete links" do
    log_in_as(@user)
    
    expect do
      delete user_path(@other_user)
    end.to change { User.count }.by(-1)
    expect(response).to redirect_to users_path
  end



end

RSpec.describe "アカウント有効化", type: :system do

  before do
    @user = FactoryBot.create(:user,:not_activation)
    
  end

  it "activation_tokenが正しくない時" do
  
    visit edit_account_activation_path("invalid",email:@user.email)
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Invalid activation link")
    
    expect(page).to have_link href: login_path
  end

  it "emailが正しくない時" do
  
    visit edit_account_activation_path("invalid",email:"111@111.com")
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Invalid activation link")
  
    expect(page).to have_link href: login_path
  end


  it "valid signup information with account activation" do
    
    
    visit edit_account_activation_path(@user.activation_token,email:@user.email)
    expect(current_path).to eq(user_path(@user))
    expect(page).to have_content("Account activated!")
    find(".dropdown-toggle").click
    
    expect(page).to have_link href: logout_path

  end
end

RSpec.describe "パスワードreset", type: :system do

  before do
    @user = FactoryBot.create(:user)
    
  end

  it 'password/new createでemailが正しくない時' do
    visit password_resets_new_path
    fill_in 'Email', with:"abc@111.com"
    find('input[name="commit"]').click
    expect(page).to have_content("Email address not found")
  end

  it 'password/new createでemailが正しい時' do
    visit password_resets_new_path
    fill_in 'Email', with: @user.email
    find('input[name="commit"]').click
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Email sent with password reset instructions")

  end
end
RSpec.describe "パスワードreset", type: :request do

  before do
    @user = FactoryBot.create(:user)
    @user.create_reset_digest 
  end

  it 'password/edit ユーザーが無効の場合(not_activate)' do
    @user.toggle!(:activated)
    # toggle!は真偽を反対にする　この場合falseにしている
    get edit_password_reset_path(@user.reset_token,email:@user.email)

    expect(response.body).to redirect_to root_path
    
  end

  it 'password/editでemailが正しくない時' do
    get edit_password_reset_path(@user.reset_token,email:"111@111.com")
    expect(response).to redirect_to root_path
    
  end

  it 'password/editでreset_tokenが正しくない時' do
    get edit_password_reset_path("invalid",email:"@user.email")
    expect(response).to redirect_to root_path
   
  end

  it 'password/editでreset_tokenが正しい時' do
    get edit_password_reset_path(@user.reset_token,email:@user.email)

    expect(response.body).to include "Reset password"

  end

  it 'password/updateでpasswordが空の時' do
    patch password_reset_path(@user.reset_token),
    params:{ email:@user.email,
             user:{
              password: "",
             },
    }
    expect(response.body).to include "Reset password"

  end

  it 'password/updateでpasswordとpassword_confirmationが無効な時' do
    patch password_reset_path(@user.reset_token),
    params:{ email:@user.email,
             user:{
              password: "abcdef",
              password_confirmation: "123456",
             },
    }
    expect(response.body).to include "Reset password"
    

  end

  it 'password/updateで正しくpasswordとpassword_confirmationが入力されている場合' do
    patch password_reset_path(@user.reset_token),
    params:{ email:@user.email,
             user:{
              password: "abcdef",
              password_confirmation: "abcdef",
             },
    }
    expect(response).to redirect_to user_path(@user)
    expect(is_login?).to be_truthy
    expect(@user.reload.reset_digest).to eq nil
    

  end

  it 'Password resetが時間切れの場合' do
    @user.update_attribute(:reset_sent_at, 5.hours.ago)
    patch password_reset_path(@user.reset_token),
    params:{ email:@user.email,
      user:{
       password: "abcdef",
       password_confirmation: "abcdef",
      },
    }
    expect(response).to redirect_to new_password_reset_url
  end



  end

  






end

  



