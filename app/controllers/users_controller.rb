# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find_by(id: params[:format])
    @comment = Comment.new
    @like = Like.new
    @post = Post.new
    @friendship = Friendship.new
  end

  def edit 
    @user = User.find_by(id: params[:format])
  end 
  


  def index
    @users = User.where('id != ?', current_user.id)
    @posts = Post.all
    @friendship = Friendship.new
    if params[:search]
      @users = User.search(params[:search]).all.order('created_at DESC').paginate(:per_page => 7, :page => params[:page])
    else 
      @users = User.all.order('created_at DESC').paginate(:per_page => 7, :page => params[:page])
    end
  end

end
