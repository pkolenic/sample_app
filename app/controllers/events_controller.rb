class EventsController < ApplicationController
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def index
    @events = Event.all
    @date = params[:month] ? DateTime.strptime(params[:month], '%Y-%m') : Date.today
    @event = current_user.events.build if signed_in?
  end

  def show
    @event = Event.find(params[:id])
  end

  def create    
    @event = current_user.events.build(event_params)
    @date = params[:month] ? DateTime.strptime(params[:month], '%Y-%m') : Date.today
    if @event.save
      @events = Event.all
      flash[:success] = "Event created!"
      redirect_to calendar_url
    else
      @show_form = true
      @events = Event.all
      render 'events/index'
    end
  end

  def destroy
    @event.destroy    
    redirect_to current_user
  end
    
  private

    def event_params
      params.require(:event).permit(:title, :deck, :start_time, :end_time)
    end  
    
    def correct_user
      @event = current_user.events.find_by(id: params[:id])
      redirect_to current_user if @event.nil?
    end
end