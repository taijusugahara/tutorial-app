require 'rails_helper'

RSpec.describe "Relationships", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user)
    @other_users=FactoryBot.create_list(:user, 10)
    # 下でフォロー、フォロワーの関係を作っている
    # 一番でいうとfollowing_idは@user これはactive_relationship時に
    # foreignキーとして設定してる（モデル見ればわかる）

    @other_users[0..9].each do |other_user|
      @user.active_relationships.create!(followed_id: other_user.id)
      @user.passive_relationships.create!(follower_id: other_user.id)
    end
    
  end

  it 'following page' do 
    log_in(@user)
    visit following_user_path(@user)
    expect(@user.following).not_to be_empty
    expect(page).to have_content(@user.following.count)
    @user.following.each do |user|
      expect(page).to have_content(user.name)
      expect(page).to have_link href: user_path(user)
    end
    
  end

  it 'follower page' do
    log_in(@user)
    visit followers_user_path(@user)
    expect(@user.following).not_to be_empty
    expect(page).to have_content(@user.followers.count)
    @user.followers.each do |user|
      expect(page).to have_content(user.name)
      expect(page).to have_link href: user_path(user)
    end
  end

  it 'follow unfollow' do
    log_in(@user)
    visit user_path(@other_user)
    # expect(page).to have_content("Follow")
    expect do
      click_on 'Follow'
      sleep 1
    end.to change{Relationship.count}.by(1)
    # expect(page).not_to have_content("Follow")
    # expect(page).to have_content("Unfollow")
    
    expect do
      click_on 'Unfollow'
      sleep 1
    end.to change{Relationship.count}.by(-1)
    

  end


end


RSpec.describe "Microposts", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user)
    @other_users=FactoryBot.create_list(:user, 10)
    # 下でフォロー、フォロワーの関係を作っている
    # 一番でいうとfollowing_idは@user これはactive_relationship時に
    # foreignキーとして設定してる（モデル見ればわかる）

    # @follow=@user.active_relationships.create!(followed_id: @other_user.id)
    @other_users[0..9].each do |other_user|
      @user.active_relationships.create!(followed_id: other_user.id)
      @user.passive_relationships.create!(follower_id: other_user.id)
    end
    
  end

  it "create should require logged-in user" do
    expect do
    post relationships_path
    end.to change{Relationship.count}.by(0)
    expect(response).to redirect_to login_path
  end

  it "destroy should require logged-in user" do
    @follow=@user.active_relationships.create!(followed_id: @other_user.id)
    expect do
      delete relationship_path(@follow)
    end.to change{Relationship.count}.by(0)
      expect(response).to redirect_to login_path
    
  end

  it "should follow a user the standard way" do
     log_in_as(@user)
     expect do
      post relationships_path, params: { followed_id: @other_user.id }
     end.to change{Relationship.count}.by(1)
  end

  it "should follow a user with Ajax" do
    log_in_as(@user)
    expect do
     post relationships_path, xhr: true,  params: { followed_id: @other_user.id }
    end.to change{Relationship.count}.by(1)
  end

  it "should unfollow a user the standard way" do
    log_in_as(@user)
    # @user.follow(@other_user)
    @follow=@user.active_relationships.create!(followed_id: @other_user.id)
    expect do
      delete relationship_path(@follow)
    end.to change{Relationship.count}.by(-1)
  end

  it "should unfollow a user with Ajax" do
    log_in_as(@user)
    # @user.follow(@other_user)
    @follow=@user.active_relationships.create!(followed_id: @other_user.id)
    expect do
      delete relationship_path(@follow), xhr: true
    end.to change{Relationship.count}.by(-1)
  end
end


