module Api::V1
  class EventsController < ApiController
    before_action :doorkeeper_authorize!
    before_action :set_event, only: [:update, :destroy]

    # GET /api/v1/events
    def index
      @events = Event.all
      events_count = @events.count
      event_serializer = parse_json @events
      json_response "Query Events Successfully", true, {count: events_count, results: event_serializer}, :ok
    end

    def create
    end

    # PUT /api/v1/events/1
    def update
      if @event.update(event_params)
        render json: @event
      else
        render json: @event.errors, status: :unprocessable_entity
      end
    end

    def destroy
    end

    private
      
      def set_event
        @event = Event.find(params[:id])
      end

      def event_params
        params.permit(:title, :content, :cover_image)
      end
  end
end