class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :invalid

  private

  def not_found(error)
    render json: ErrorSerializer.serialize(error), status: 404
  end

  def invalid(error)
    render json: ErrorSerializer.serialize(error), status: 400
  end
end
