module Response
  # def json_response messages, is_success, data, status
  #   render json: {
  #     response_message: messages,
  #     is_success: is_success,
  #     data: data
  #   }, status: status
  # end

  def json_response messages, is_success, data, status
    render json: data
  end
end