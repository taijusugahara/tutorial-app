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

  it "email should be present" do
    @user.email = "     "
    expect(@user).not_to be_valid
  end

  it "name should not be too long" do
    @user.name = "a" * 51
    expect(@user).not_to be_valid
  end

  it "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    expect(@user).not_to be_valid
  end

  it "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      expect(@user).to be_valid
      #  @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  it "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      expect(@user).not_to be_valid
    end
  end

  it "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    expect(duplicate_user).not_to be_valid
  end
end
