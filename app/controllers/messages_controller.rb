class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @message = current_user.messages.build(message_params)
    @message.room = current_room

    if @message.save
      # respond_to do |format|
      #   format.json { redirect_to posts_url }
      #   format.html { ActionCable.server.broadcast "messages_room_#{current_room.id}",
      #     render(partial: 'partials/message', object: @message ) }
      # end
      ActionCable.server.broadcast "messages_room_#{current_room.id}",
                                    message: render_message(@message)
      # redirect_to posts_path(current_user, current_room.id) and return if current_user

      #flash[:notice] = "Comment has been created"
    end
    # redirect_to posts_path(current_user, roomId: current_room.id)
  end

  private 
  def message_params
    params.require(:message).permit(:body)
  end
  def render_message(message)
   self.render(partial: 'partials/message', object: message )
    # redirect_to :back
 end
end