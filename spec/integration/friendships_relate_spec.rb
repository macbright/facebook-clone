# frozen_string_literal: true

require 'rails_helper'
require 'rspec/rails'

RSpec.describe 'friendships process', type: :feature do
  before :each do
    @user1 = User.create!(name: 'Bright okike',
                          email: 'brightokike5@gmail.com',
                          password: 'foobar',
                          password_confirmation: 'foobar')

    @user2 = User.create!(name: 'kelvin liang',
                          email: 'kelvin5@gmail.com',
                          password: 'foobar',
                          password_confirmation: 'foobar')
  end

  it 'Request a friendship' do
    visit '/login'
    page.fill_in 'signin_email', with: 'brightokike5@gmail.com'
    page.fill_in 'signin_password', with: 'foobar'
    click_on('Sign In')
    expect(page).to have_content 'Signed in successfully.'

    visit users_index_path
    first(:button, 'Add As Friend').click
    expect(page).to have_content 'Friend request sent'

    visit friends_path
    expect(page).to have_content 'Friend Request Sent'
    expect(find(:link, 'Cancel Request')).not_to be(nil)

    find(:css, '.dropdown').click_on('Sign Out')
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it ' cancel already sent friend request' do
    visit '/login'
    page.fill_in 'signin_email', with: 'brightokike5@gmail.com'
    page.fill_in 'signin_password', with: 'foobar'
    click_on('Sign In')

    visit user_path(@user2)
    click_on('Add As Friend')

    visit '/friends'
    click_on('Cancel Request')
    expect(page).to have_content 'Friend Request Canceled'
  end

  it ' confirm friend request' do
    visit '/login'
    page.fill_in 'signin_email', with: 'brightokike5@gmail.com'
    page.fill_in 'signin_password', with: 'foobar'
    click_on('Sign In')

    visit user_path(@user2)
    click_on('Add As Friend')
    click_on('Sign Out')

    visit '/login'
    page.fill_in 'signin_email', with: 'kelvin5@gmail.com'
    page.fill_in 'signin_password', with: 'foobar'
    click_on('Sign In')
    expect(page).to have_content '1'

    visit '/friends'
    click_on('Confirm Request')
    expect(page).to have_content 'Friend Request Confirmed'
  end
end
