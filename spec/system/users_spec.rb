require 'rails_helper'


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
      fill_in 'Confirmation', with: "101010"
      expect do
        find('input[name="commit"]').click
      end.to change { User.count }.by(0)

      expect(page).to have_content('Sign up')
      # これは違う
      # expect(current_path).to eq(users_path)
      
      expect(has_css?('.alert-danger')).to be_truthy
      


    end
  end

  



end