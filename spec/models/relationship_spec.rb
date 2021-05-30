require 'rails_helper'

RSpec.describe Relationship, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @other_user= FactoryBot.create(:user)
     @relationship = Relationship.new(follower_id:@user.id,
                                followed_id:@other_user.id)

  end


  it "should be valid" do
    expect(@relationship).to be_valid
  end

  it "should require a follower_id" do
    @relationship.follower_id = nil
    expect(@relationship).not_to be_valid
  end

  it "should require a followed_id" do
    @relationship.followed_id = nil
    expect(@relationship).not_to be_valid
  end

  


end
