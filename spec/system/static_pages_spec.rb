require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  it 'should get home' do
    visit static_pages_home_path
    expect(current_path).to eq (static_pages_home_path)
    expect(page).to have_title "Home | #{@base_title}"

  end

  it 'should get help' do
    visit static_pages_help_path
    expect(current_path).to eq (static_pages_help_path)
    expect(page).to have_title "Help | #{@base_title}"

  end

  it 'should get about' do
    visit static_pages_about_path
    expect(current_path).to eq (static_pages_about_path)
    expect(page).to have_title "About | #{@base_title}"

  end
end
