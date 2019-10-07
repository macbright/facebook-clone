class FriendshipsController < ApplicationController
  def create
    @friendship = current_user.friendships.build(friendship_params)
    if @friendship.save
      flash[:success] = 'Friend request sent'
      redirect_to users_path
    end
  end

  def destroy
    @friend1 = Friendship.where(user_id: params[:format], friend_id: current_user.id)
    @friend2 = Friendship.where(user_id: current_user.id, friend_id: params[:format])
    @friend = @friend1 ? @friend1 : @friend2
    # byebug
    flash[:danger] = 'Removed Friend' if @friend.delete_all
    redirect_to users_path
  end

  def confirm
    @user = User.find_by(id: params[:format])
    current_user.confirm_friend(@user)
    redirect_to friends_path
  end

  def cancel
    @user = User.find_by(id: params[:format])
    current_user.cancel_friend_request(@user)
    redirect_to friends_path
  end

  private
  def friendship_params
    params.require(:friendship).permit(:user_id, :friend_id)
  end
end
