class Api::V1::ApiController < ActionController::Base
  before_filter :restrict_access
  respond_to :json

  private
  def restrict_access
    @current_user = nil

    # if Rails.env.production?
    #  authenticate_or_request_with_http_token do |token, options|
    #    @current_user = User.find_by_api_key token      
    #  end
    # else
    @current_user = User.find_by_api_key params[:token]
    head :unauthorized unless @current_user
    # end

    @current_user
  end
end
