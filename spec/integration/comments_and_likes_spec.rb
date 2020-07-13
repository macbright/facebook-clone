# frozen_string_literal: true

require 'rails_helper'
require 'rspec/rails'

RSpec.describe 'Comment and Like functions', type: :feature do
  before :each do
    @user = User.create!(name: 'Example User',
                         email: 'example@gmail.com',
                         password: 'foobar',
                         password_confirmation: 'foobar')

    @post = @user.posts.create!(content: 'this is a post for testing')
  end

  it 'can post comment after login.' do
    visit root_url
    fill_in('signin_email', with: 'example@gmail.com')
    fill_in('signin_password', with: 'foobar')
    click_on('Sign In')
    expect(page).to have_content 'Signed in successfully.'

    fill_in('comment[content]', with: 'Test Answer!')
    click_on('Post Your Answer')
    expect(page).to have_content 'Comment Saved.'
    expect(page).to have_content 'Test Answer!'
  end

  it 'can like and unlike after login' do
    visit root_url
    fill_in('signin_email', with: 'example@gmail.com')
    fill_in('signin_password', with: 'foobar')
    click_on('Sign In')
    expect(page).to have_content 'Signed in successfully.'

    click_on('Like')
    expect(page).to have_content 'You Liked!'
    expect(page).to have_link 'unlike'
    expect(page).to have_selector 'span.mx-1', text: '1'

    click_on('unlike')
    expect(page).to have_content 'You Unliked!'
    expect(page).to have_button 'Like'
    expect(page).to have_selector 'span.mx-1', text: '0'
  end
end
