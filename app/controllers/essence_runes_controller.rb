class EssenceRunesController < ApplicationController
  include RuneHelper

  before_action :rune_lore_master
  
  def edit    
    @rune = EssenceRune.find(params[:id])
  end
  
  def update
    @rune = EssenceRune.find(params[:id])
    if @rune.update_attributes(rune_params)
      flash[:success] = "rune updated"
      redirect_to runes_path
    else
      render 'edit'
    end    
  end
  
  def destroy
    @rune = EssenceRune.find(params[:id])
    @rune.destroy    
    redirect_to runes_url    
  end
  
    private
  
    def rune_params
      params.require(:essence_rune).permit(:name, :translation)
    end 
    
end