module Api::V1
  class EventsController < ApiController
    before_action :doorkeeper_authorize!
    before_action :set_event, only: [:show, :update, :destroy]

    # GET /api/v1/events
    def index
      @events = Event.page params[:page]
      event_serializer = parse_json @events
      set_pagination_header(:events)
      setup_headers(@events)
      if @offset < @count
        json_response "Fetching Events Successfully", true, {count: @count, previous: @previous, next: @next, results: event_serializer}, :ok
      else
        json_response "Failed fetching event", false, {detail: "Invalid page."}, :unprocessable_entity
      end
    end

    # GET /api/v1/events/1
    def show
      if !@event.nil?
        event_serializer = parse_json @event
        json_response "Fetching event successfully", true, {results: event_serializer}, :ok
      else
        json_response "Failed fetching event", false, {results: []}, :unprocessable_entity
      end
    end

    # POST /api/v1/events
    def create
      @event = Event.new(convert_data_uri_to_upload(user_params))
      if @event.save
        event_serializer = parse_json @event
        json_response "Creating event successfully", true, {results: event_serializer}, :ok
      else 
        json_response "Failed creating event", false, {results: []}, :unprocessable_entity
      end
    end

    # PUT /api/v1/events/1
    def update
      if @event.update(event_params)
        event_serializer = parse_json @event
        json_response "Updating event successfully", true, {results: event_serializer}, :ok
      else
        json_response "Failed updating event", false, {results: []}, :unprocessable_entity
      end
    end

    # DELETE /api/v1/events/1
    def destroy
      if @event.destroy
        json_response "Event successfully deleted", true, {results: []}, :ok
      else
        json_response "Failed delete event", false, {results: []}, :unprocessable_entity
      end
    end


    private
      
      def set_event
        @event = Event.find(params[:id])
      end

      def event_params
        params.permit(:title, :content, :cover_image, :category_id, :user_id)
      end

      def setup_headers(events)
        @count  = events.total_count
        @offset = events.offset_value
        @limit = events.limit_value
      end


      def set_pagination_header(name, options = {})
        scope = instance_variable_get("@#{name}")
        request_params = request.query_parameters
        url_without_params = request.original_url.slice(0..(request.original_url.index("?")-1)) unless request_params.empty?
        url_without_params ||= request.original_url

        page = {}
        # page[:first] = 1 if scope.total_pages > 1 && !scope.first_page?
        # page[:last] = scope.total_pages  if scope.total_pages > 1 && !scope.last_page?
        page[:next] = scope.current_page + 1 unless scope.last_page?
        page[:prev] = scope.current_page - 1 unless scope.first_page?

        pagination_links = []
        page.each do |k, v|
          new_request_hash= request_params.merge({:page => v})
          pagination_links << "<#{url_without_params}?#{new_request_hash.to_param}>; rel=\"#{k}\""
          if k.to_s == "next"
            @next = "#{url_without_params}?#{new_request_hash.to_param}"
          elsif k.to_s == "prev"
            @previous = "#{url_without_params}?#{new_request_hash.to_param}"
          end
        end
      end

      # Image upload
      def split_base64(uri_str)
        if uri_str.match(%r{^data:(.*?);(.*?),(.*)$})
          uri = Hash.new
          uri[:type] = $1 # "image/jpg"
          uri[:encoder] = $2 # "base64"
          uri[:data] = $3 # data string
          uri[:extension] = $1.split('/')[1] # "jpg"
          return uri
        else
          return nil
        end
      end

      def convert_data_uri_to_upload(obj_hash)
        if obj_hash[:image_url].try(:match, %r{^data:(.*?);(.*?),(.*)$})
          image_data = split_base64(obj_hash[:image_url])
          image_data_string = image_data[:data]
          image_data_binary = Base64.decode64(image_data_string)

          temp_img_file = Tempfile.new("")
          temp_img_file.binmode
          temp_img_file << image_data_binary
          temp_img_file.rewind

          img_params = {:filename => "image.#{image_data[:extension]}", :type => image_data[:type], :tempfile => temp_img_file}
          uploaded_file = ActionDispatch::Http::UploadedFile.new(img_params)

          obj_hash[:image] = uploaded_file
          obj_hash.delete(:image_url)
        end
        return obj_hash    
      end
  end
end