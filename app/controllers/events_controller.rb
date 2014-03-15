class EventsController < ApplicationController
  before_action :has_event_creation_rights, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def index
    if current_user && current_user.rank_id > UserPending
      @events = Event.all
    else
      @events = Event.all.public
    end
    @date = params[:month] ? DateTime.strptime(params[:month], '%Y-%m') : Date.today
    @event = current_user.events.build if signed_in?
  end

  def show
    @event = Event.find(params[:id])
    unless @event.public 
      unless signed_in? && current_user.rank_id > UserPending    
        flash[:error] = "Only full guild members can view that event!"
        redirect_to calendar_url
      end      
    end
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
      params.require(:event).permit(:title, :deck, :start_time, :end_time, :public)
    end  
    
    def correct_user
      @event = current_user.events.find_by(id: params[:id])
      redirect_to current_user if @event.nil?
    end
    
    def has_event_creation_rights
      if signed_in?
        unless current_user.rank_id >= UserGuildMaster
          flash[:error] = "You don't have permissions to create an Event!"
          redirect_to calendar_url        
        end        
      else
        store_location
        redirect_to signin_url, notice: "Please sign in."        
      end
    end    
end