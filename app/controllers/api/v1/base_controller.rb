class Api::V1::BaseController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :bad_request

  private

  def not_found
    render json: { error: 'Resource not found' }, status: :not_found
  end

  def bad_request
    render json: { error: 'Bad request' }, status: :bad_request
  end
end
