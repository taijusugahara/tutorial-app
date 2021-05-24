require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  

  it 'should get home' do
    visit static_pages_home_path
    expect(current_path).to eq (static_pages_home_path)

  end

  it 'should get help' do
    visit static_pages_help_path
    expect(current_path).to eq (static_pages_help_path)

  end

  it 'should get about' do
    visit static_pages_about_path
    expect(current_path).to eq (static_pages_about_path)

  end
end
