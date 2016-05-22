class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_filter -> { request.format = :json }

  rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :bad_request

  def not_found
    render json: { "error" => "not_found" }, status: 404
  end

  def bad_request
    render nothing: true, status: 400
  end
end
