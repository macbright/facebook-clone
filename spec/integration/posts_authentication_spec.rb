# frozen_string_literal: true

require 'rails_helper'
require 'rspec/rails'

RSpec.describe 'Post authentication', type: :feature do
  fixtures :users

  before do
    @user = User.create!(name: 'Bright okike',
                         email: 'brightokike5@gmail.com',
                         password: 'foobar',
                         password_confirmation: 'foobar')
  end

  it 'unsuccessful post creation' do
    visit '/login'
    page.fill_in 'signin_email', with: 'brightokike5@gmail.com'
    page.fill_in 'signin_password', with: 'foobar'
    click_on('Sign In')

    visit root_url

    click_on('Ask Question')
    # page.fill_in 'content', with: 'money'
    click_on('Ask')

    expect(page).to have_content 'content cant be empty or less than 10 letter'
  end

  # it 'successful post creation' do
  #   visit '/login'
  #   page.fill_in 'signin_email', with: 'brightokike5@gmail.com'
  #   page.fill_in 'signin_password', with: 'foobar'
  #   click_on('Sign In')

  #   visit root_url
  #   click_on('Ask Question')
  #   page.fill_in 'content', with: 'money is good'
  #   click_on('Ask')

  #   expect(page).to have_content 'Post created'
  # end

  it 'visit root page' do
    visit '/login'
    page.fill_in 'signin_email', with: 'brightokike5@gmail.com'
    page.fill_in 'signin_password', with: 'foobar'
    click_on('Sign In')

    visit root_url
    expect(page).to have_content @user.first_name
    expect(page).to have_content 'Connect Developers'
  end
end
