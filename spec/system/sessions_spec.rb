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
end



