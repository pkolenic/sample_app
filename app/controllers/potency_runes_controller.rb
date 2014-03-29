class PotencyRunesController < ApplicationController
  include RuneHelper

  before_action :rune_lore_master
  
  def edit    
    @rune = PotencyRune.find(params[:id])
  end
  
  def update
    @rune = PotencyRune.find(params[:id])
    if @rune.update_attributes(rune_params)
      flash[:success] = "rune updated"
      redirect_to runes_path
    else
      render 'edit'
    end    
  end
  
  def destroy
    @rune = PotencyRune.find(params[:id])
    @rune.destroy    
    redirect_to runes_url    
  end
  
    private
  
    def rune_params
      params.require(:potency_rune).permit(:name, :translation, :level, :gear_level_id, :glyph_prefix_id)
    end 
    
end