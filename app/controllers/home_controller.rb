# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.find_by(id: params[:format])
    @like = Like.new
    @comment = Comment.new
    if params[:search]
      @posts = Post.search(params[:search]).all.order('created_at DESC').paginate(:per_page => 3, :page => params[:page])
    else 
      @posts = Post.all.order('created_at DESC').paginate(:per_page => 3, :page => params[:page])
    end
  end

  def friends
    @user = current_user
  end
end


