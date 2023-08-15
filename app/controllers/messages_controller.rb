class MessagesController < ApplicationController
  # params { message: { body, rooms_ids, users_ids } }
  def create
    rooms_ids = params[:message][:rooms_ids]
    create_message_for(Room.users_type.where(id: rooms_ids)) if rooms_ids.present?

    users_ids = params[:message][:users_ids]
    if users_ids.present?
      User.where(id: users_ids).each do |user|
        room = Room.find_or_create_by(title: current_user.room_title_with(user), room_type: :user)
        create_message_for(room)
      end
    end
  end

  def new
    @new_message = Message.new
    if params[:multiple] == 'true'
      @multiple = true
      @users = User.all
      @rooms = Room.users_type
    end
  end

  private

  # _for(*rooms) for AR::Relation return [AR::Relation]
  def create_message_for(rooms)
    [*rooms].each do |room|
      new_message = room.messages.build(message_params.merge(user: current_user))
      broadcast(new_message) if new_message.save
    end
  end

  def message_params
    params.require(:message).permit(:body)
  end

  def broadcast(new_message)
    room = new_message.room
    room_target = :"room_#{room.id}_messages"

    new_message.broadcast_append_to room, target: room_target, locals: { message: new_message, current_user: User.new }
    new_message.broadcast_append_to [current_user, room], target: room_target,
      locals: { message: new_message, current_user: current_user }
  end
end
