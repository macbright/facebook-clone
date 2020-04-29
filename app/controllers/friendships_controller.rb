# frozen_string_literal: true

class FriendshipsController < ApplicationController
  def create
    @friendship = current_user.friendships.build(friendship_params)
    return unless @friendship.save

    flash[:success] = 'Friend request sent'
    redirect_to users_index_path
  end

  def destroy
    # @friend1 = Friendship.where(user_id: params[:format], friend_id: current_user.id)
    # @friend2 = Friendship.where(user_id: current_user.id, friend_id: params[:format])
    # @friend = @friend1 || @friend2
    @user = User.find_by(user_id: params[:format])
    current_user.friends.delete(@user)
    flash[:danger] = 'Removed Friend'
    redirect_to users_index_path
  end

  def confirm
    @user = User.find_by(id: params[:format])
    current_user.confirm_friend(@user)
    flash[:success] = 'Friend Request Confirmed'
    redirect_to friends_path
  end

  def cancel
    @user = User.find_by(id: params[:format])
    current_user.cancel_friend_request(@user)
    flash[:success] = 'Friend Request Canceled'
    redirect_to friends_path
  end

  def ignore
    @user = User.find_by(id: params[:format])
    @friendship = Friendship.find { |f| f.user_id == @user.id }
    @friendship.destroy
    flash[:danger] = 'Friend Request Ignored'
    redirect_to friends_path
  end

  private

  def friendship_params
    params.require(:friendship).permit(:user_id, :friend_id)
  end
end
