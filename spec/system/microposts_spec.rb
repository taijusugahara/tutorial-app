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

  it 'user/showのmicroposts' do
    log_in(@user)
    visit user_path(@user)
    Micropost.paginate(page: 1).each do |micropost|
      # expect(page).to have_link href: user_path(micropost.user)
      expect(page).to have_content(micropost.user.name)
      expect(page).to have_content(micropost.content)
    end
  end

    it 'micropost sidebar count' do
      log_in(@user)
       visit root_path
      expect(page).to have_content("34 microposts")
      log_in(@micropost.user)
      visit root_path
      expect(page).to have_content("1 micropost")

    end

    it 'micropost interface 全体の流れ(micropost)' do
      log_in(@user)
      visit root_path
      expect(page).to have_link"Next"
      # これでページネーションあること（３０個以上micropostあること）示す
      fill_in 'micropost_content', with: "How are you?"
              #  labelがない場合idでもいい micropost_contentはid
              image_path = Rails.root.join('spec/fixtures/kitten.jpg')
              attach_file('micropost[image]', image_path, make_visible: true)
      # attach_file 'micropost_image', with: "#{Rails.root}/spec/fixtures/kitten.jpg"
      expect do
        find('input[name="commit"]').click
      end.to change { Micropost.count }.by(1)
      expect do 
        all('ol li')[0].click_link 'delete'
        # deleteを押すとYou sureというconfirmが出るのでそれの対処
        # expectのブロック内にひとつ以上のexpectもしくはfindを入れないと、
        # ダイアログが表示されてacceptされる前に次へ進んでしまうので注意が必要らしい
        page.accept_confirm "You sure?"
        # ここ！！！大事 これでOKの役割
        expect(page).to have_content("Micropost deleted")
        # 上の理由によりこれもいる
      end.to change { Micropost.count }.by(-1)
      # ＋＠
      # pageインスタンスにaccept_confirmとdismiss_confirmという
      # ブラウザのダイアログ操作用メソッドが用意されていてる
      # dismissに変えたところmicropostは減らなかった
      visit user_path(@micropost.user)
      expect(page).not_to have_link 'delete'
  
  
    end
 

end

RSpec.describe "Microposts", type: :request do
  before do
    @micropost = FactoryBot.create(:micropost)
    @other_micropost = FactoryBot.create(:micropost)
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

  it "should redirect destroy for wrong micropost" do
    log_in_as(@micropost.user)
    expect do
      delete micropost_path(@other_micropost)
                              # こことか
    end.to change { Micropost.count }.by(0)
    expect(response).to redirect_to root_path
  end

end

RSpec.describe "Microposts", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  it 'micropost interface 全体の流れ(micropost)' do
    log_in(@user)
    visit root_path
    fill_in 'micropost_content', with: "How are you?"
    expect do
      find('input[name="commit"]').click
    end.to change { Micropost.count }.by(1)
    expect do 
      click_link 'delete'
      # deleteを押すとYou sureというconfirmが出るのでそれの対処
      # expectのブロック内にひとつ以上のexpectもしくはfindを入れないと、
      # ダイアログが表示されてacceptされる前に次へ進んでしまうので注意が必要らしい
      page.accept_confirm "You sure?"
      # ここ！！！大事 これでOKの役割
      expect(page).to have_content("Micropost deleted")
      # 上の理由によりこれもいる
    end.to change { Micropost.count }.by(-1)
    # ＋＠
    # pageインスタンスにaccept_confirmとdismiss_confirmという
    # ブラウザのダイアログ操作用メソッドが用意されていてる
    # dismissに変えたところmicropostは減らなかった


  end

end