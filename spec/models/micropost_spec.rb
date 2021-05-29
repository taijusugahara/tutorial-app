require 'rails_helper'

RSpec.describe Micropost, type: :model do
  before do
    @micropost = FactoryBot.create(:micropost)
  end

  it "should be valid" do
    expect(@micropost).to be_valid
  end

  it "user id should be present" do
    @micropost.user = nil
    expect(@micropost).not_to be_valid
  end

  it "content should be present" do
    @micropost.content = "   "
    expect(@micropost).not_to be_valid
  end

  it "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    expect(@micropost).not_to be_valid
  end


end

RSpec.describe Micropost, type: :model do
  before do
    @one_week_ago = FactoryBot.create(:micropost,:one_week_ago)
    @now = FactoryBot.create(:micropost,:now)
    @yesterday = FactoryBot.create(:micropost,:yesterday)
    
   
  end

  it 'order should be most recent first' do
  expect(Micropost.first).to eq @now
  end

end

RSpec.describe Micropost, type: :model do
  before do
    @micropost = FactoryBot.create(:micropost)
  end

  it 'associated microposts should be destroyed' do
    expect do
    @micropost.user.destroy
  end.to change(Micropost, :count).by(-1)

  end


end