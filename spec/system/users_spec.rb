require 'rails_helper'


RSpec.describe "Users", type: :system do

  it 'should get new' do
    visit signup_path
    expect(current_path).to eq (signup_path)
  end



end