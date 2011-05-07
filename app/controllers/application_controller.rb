# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :authenticate
  layout 'fusion'

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  protected
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "fusion" && password == "3n3my0fcha0s"
    end
  end
end
