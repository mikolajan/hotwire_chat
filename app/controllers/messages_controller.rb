class MessagesController < ApplicationController
  def create
    @new_message = current_user.messages.build(message_params)

    broadcast_new_message if @new_message.save
  end

  private

  def message_params
    params.require(:message).permit(:body).merge(room_id: params[:room_id])
  end

  def broadcast_new_message
    room = @new_message.room
    room_target = :"room_#{room.id}_messages"

    @new_message.broadcast_append_to room, target: room_target, locals: { message: @new_message, current_user: nil }
    @new_message.broadcast_append_to [current_user, room], target: room_target,
      locals: { message: @new_message, current_user: current_user }
  end
end
