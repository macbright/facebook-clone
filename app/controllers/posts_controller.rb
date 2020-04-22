# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!

  def new
    @post = Post.new
    @posts = Post.all
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = 'Post created'
      redirect_to root_path
    else
      flash[:danger] = 'content cant be empty or less than 10 letter'
      render 'new'
    end
  end

  def index
    @user = User.find_by(id: params[:format])
    @comment = Comment.new
    @like = Like.new
    @post = Post.find_by(id: params[:format])
    @friendship = Friendship.new
    if params[:search]
      @posts = Post.search(params[:search]).all.order('created_at DESC').paginate(:per_page => 3, :page => params[:page])
    else 
      @posts = Post.all.order('created_at DESC').paginate(:per_page => 3, :page => params[:page])
    end
  end

  def edit
    @post = Post.find_by(id: params[:format])
    @like = Like.new
    @posts = Post.all
    @comment = Comment.new
  end

  def show
    @like = Like.new
    if params[:search]
      @posts = Post.search(params[:search]).all.order('created_at DESC').paginate(:per_page => 3, :page => params[:page])
    else 
      @posts = Post.all.order('created_at DESC').paginate(:per_page => 3, :page => params[:page])
    end
    @comment = Comment.new
    @post = Post.find_by(id: params[:format])
  end

  def update
    @post = Post.find_by(id: params[:format])
    @posts = Post.all
    @comment = Comment.new
    if @post.update(post_params)
      flash[:success] = 'Post updated!'
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find_by(id: params[:format])
    flash[:danger] = 'Post Deleted!' if @post.destroy
    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
