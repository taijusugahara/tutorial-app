require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  it 'should be valid' do
    expect(@user).to be_valid
  end

  it "name should be present" do
    @user.name = "     "
    expect(@user).not_to be_valid
  end
end
