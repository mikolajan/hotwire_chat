class RoomsController < ApplicationController
  before_action :authenticate_user!, only: %i[create new show]

  def create
    @new_room = Room.new(room_params)

    if @new_room.save
      @new_room.broadcast_append_to :rooms
      respond_to do |format|
        format.html { redirect_to rooms_path, notice: 'Succeccfully created' }
      end
    else
      respond_to do |format|
        format.html { render :new }
      end
    end
  end

  def index
    @rooms = Room.all
  end

  def new
    @new_room = Room.new
  end

  def show
    @room = Room.find(params[:id])
  end

  private

  def room_params
    params.require(:room).permit(:title)
  end
end
