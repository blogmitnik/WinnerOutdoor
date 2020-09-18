class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  def index
    if params[:category].blank?
	  @events = Event.all.order("updated_at DESC")
	else
	  @category_id = Category.find_by(name: params[:category]).id
	  @events = Event.where(category_id: @category_id).order("updated_at DESC")
	end
  end

  # GET /events/:id
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/:id/edit
  def edit
  end

  # POST /events 
  def create
    @event = Event.new(event_params)
    @event.user_id = current_user.id
    if @event.save
      redirect_to events_path, notice: "The event was created!"
    else
      render :new
    end
  end

  # PATCH or PUT /events/:id
  def update
    if @event.update_attributes(event_params)
      redirect_to event_path(@event), notice: "Event updated successfully"
    else
      render :edit
    end
  end

  # DELETE /events/:id
  def destroy
  	@event.destroy
    redirect_to events_path, notice: "Event was destroyed"
  end

  private

  def event_params
    params.require(:event).permit(:title, :content, :cover_image, :category_id, :user_id, :cover_image_cache, :remove_cover_image)
  end

  def set_event
    @event = Event.friendly.find(params[:id])
  end
end