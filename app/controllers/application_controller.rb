class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  
  before_filter :get_tournaments
  
  def get_tournaments
    # TODO write test and show
    # @tournaments.where(['end_date > ?', DateTime.now])
    @tournaments = Tournament.all 
  end
end
