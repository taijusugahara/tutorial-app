require 'rails_helper'
# include ApplicationHelper


RSpec.describe "StaticPages", type: :system do
  
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  it 'should get root' do
    visit root_path
    expect(current_path).to eq root_path
    expect(page).to have_title " #{@base_title}"

  end

  

  it 'should get help' do
    visit help_path
    expect(current_path).to eq (help_path)
    expect(page).to have_title "Help | #{@base_title}"

  end

  it 'should get about' do
    visit about_path
    expect(current_path).to eq (about_path)
    expect(page).to have_title "About | #{@base_title}"

  end

  it 'should get contact' do
    visit contact_path
    expect(current_path).to eq (contact_path)
    expect(page).to have_title "Contact | #{@base_title}"

  end

  # 5章
  # トップページにリンクがあるかどうか
  it "layout links" do
    visit root_path
    expect(page).to have_link href: root_path, count:2
    expect(page).to have_link href: help_path
    expect(page).to have_link href: about_path
    expect(page).to have_link href: contact_path
    expect(page).to have_link href: signup_path



  end

end
