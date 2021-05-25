require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  # before do
    
  # end

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
end

