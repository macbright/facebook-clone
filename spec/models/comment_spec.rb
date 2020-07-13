# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @user = User.create!(name: 'Bright okike',
                         email: 'brightokike4@gmail.com',
                         password: 'foobar',
                         password_confirmation: 'foobar')

    @post = @user.posts.create!(content: 'this is a post for testing')
    @comment = @user.comments.build(content: 'great!', post_id: @post.id)
  end

  context 'Comment validation' do
    it 'ensures it is successfully created' do
      expect(@comment.valid?).to eql(true)
    end

    it 'ensures content is not blank' do
      @comment.content = ''
      expect(@comment.valid?).to eql(false)
    end

    # it 'ensure content can not over 150 limit.' do
    #   @comment.content = '8' * 151
    #   expect(@comment.valid?).to eql(true)
    #   @comment.content = '6'
    #   expect(@comment.valid?).to eql(true)
    #   @comment.content = 'THis is valid.'
    #   expect(@comment.valid?).to eql(false)
    # end
  end
end
