require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    @user = FactoryBot.create(:user)
    # @microposts = FactoryBot.create_list(:micropost, 32)
    34.times do
    content = Faker::Lorem.sentence(word_count: 5)
    @user.microposts.create!(content: content)
    end
  end

  it 'user/showのmicroposts' do
    log_in(@user)
    visit user_path(@user)
    Micropost.paginate(page: 1).each do |micropost|
      expect(page).to have_link href: user_path(micropost.user)
      expect(page).to have_content(micropost.user.name)
      expect(page).to have_content(micropost.content)
    end
 end

end

RSpec.describe "Microposts", type: :request do
  before do
    @micropost = FactoryBot.create(:micropost)
    # @user = FactoryBot.create(:user)
  end
# ****今気づいたけどuserとmicropostはネストの関係じゃないんだ。だからuserのidとかいらない
                      #  ここではそういう風にしてない
  it 'should redirect create when not logged in' do
    expect do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
              # こことかuserのidいらない
    end.to change { Micropost.count }.by(0)
     expect(response).to redirect_to login_url

  end

  it 'should redirect destroy when not logged in' do 
    expect do
      delete micropost_path(@micropost)
                              # こことか
    end.to change { Micropost.count }.by(0)
     expect(response).to redirect_to login_url

  end


end