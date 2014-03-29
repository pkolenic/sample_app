class RunesController < ApplicationController
  include RuneHelper
  require 'will_paginate/array'
  
  before_action :rune_lore_master, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    # @runes = Rune.paginate(page: params[:page], :per_page => 10).order(:id)
    
    @runes = EssenceRune.all.order(:id) + AspectRune.all.order(:level, :quality_id, :id) + PotencyRune.all.order(:level, :id)
    @runes = @runes.paginate(page: params[:page], :per_page => 20)
  end
  
  def new
    @rune = Rune.new
  end
  
  def create
    @rune = Rune.new(rune_params)
    
    # Make Rune based on rune_type
    case @rune.rune_type.name
     when "Essence"
       @rune = EssenceRune.new(name: @rune.name, translation: @rune.translation)
     when "Aspect"
       @rune = AspectRune.new(name: @rune.name, translation: @rune.translation, level: @rune.level, quality_id: @rune.quality_id)
     when "Potency"
       @rune = PotencyRune.new(name: @rune.name, translation: @rune.translation, level: @rune.level, gear_level_id: @rune.gear_level_id, glyph_prefix_id: @rune.glyph_prefix_id)
     else
       # clear rune as plain runes aren't to be created
       @rune = Rune.new()
     end     
    
    if @rune.save
      @runes = Rune.all
      flash[:success] = "Rune created!"
      redirect_to runes_url
    else
      @rune = Rune.new(rune_params)
      @rune.save  # Should have same errors as Specific Rune
      render 'new'
    end    
  end
  
  def edit    
    @rune = Rune.find(params[:id])
  end
  
  def update
    @rune = Rune.find(params[:id])
    if @rune.update_attributes(rune_params)
      flash[:success] = "rune updated"
      redirect_to runes_path
    else
      render 'edit'
    end    
  end
  
  def destroy
    @rune = Rune.find(params[:id])
    @rune.destroy    
    redirect_to runes_url    
  end
  
  private
  
    def rune_params
      params.require(:rune).permit(:name, :translation, :level, :quality_id, :rune_type_id, :gear_level_id, :glyph_prefix_id)
    end
end