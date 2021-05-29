require 'rails_helper'

RSpec.describe "Microposts", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @micropost = FactoryBot.create(:micropost)

    # @microposts = FactoryBot.create_list(:micropost, 32)
    34.times do
      content = Faker::Lorem.sentence(word_count: 5)
      @user.microposts.create!(content: content)
    end
    
  end

  it 'user/show interface' do 
    
  end


end