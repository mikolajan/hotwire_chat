class RoomsController < ApplicationController
  def create
    @new_room = Room.new(room_params)

    if @new_room.save
      @new_room.broadcast_append_to :rooms
      respond_to do |format|
        format.html { redirect_to rooms_path, notice: 'Succeccfully created' }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream
      end
    end
  end

  def index
    @rooms = Room.users_type
    @users = User.without_user(current_user)
  end

  def new
    @new_room = Room.new
  end

  def show
    init_room

    @new_message = @room.messages.build
    @messages = @room.messages.includes(:user)
  end

  private

  def room_params
    params.require(:room).permit(:title)
  end

  # /rooms/:id?type=user -- user_room; /rooms/:id -- users_room
  def init_room
    if params[:type] == 'user'
      user = User.find(params[:id])
      @room = Room.find_or_create_by(title: current_user.room_title_with(user), room_type: :user)
      @room.title = user.nickname
    else
      @room = Room.users_type.find(params[:id])
    end
  end
end
