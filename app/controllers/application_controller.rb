class ApplicationController < ActionController::Base
  def current_user
    return @current_user if @current_user.present?

    @current_user = current_user_from_params
  end

  private

  def current_user_from_params
    if params[:api_token].present?
      User.find_by_api_token(params[:api_token])
    elsif params[:email].present?
      User.find_by_credentials(params[:email], params[:password])
    end
  end
end
