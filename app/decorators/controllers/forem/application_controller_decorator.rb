Forem::ApplicationController.class_eval do
  before_filter :signed_in_user
end