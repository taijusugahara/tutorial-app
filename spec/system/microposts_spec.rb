require 'rails_helper'

RSpec.describe "Microposts", type: :system do
  before do
    @user = FactoryBot.create(:user)
    # @microposts = FactoryBot.create(:micropost)
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