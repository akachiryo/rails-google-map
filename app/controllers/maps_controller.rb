class MapsController < ApplicationController

  def result
    current_location = [params[:lat].to_f, params[:lng].to_f]
    @spots = Map.near(current_location, params[:distance], units: :km)
    redirect_to :action => "index", spots: @spots.to_json
  end

  def index
    @maps = Map.all
    @map = Map.new
    @spots = JSON.parse(params[:spots]) if params[:spots]
  end

  def create
      map = Map.new(map_params)
      if map.save
          redirect_to :action => "index"
      else
          redirect_to :action => "index"
      end
  end

  def destroy
      map = Map.find(params[:id])
      map.destroy
      redirect_to action: :index
  end

  def search
  end

  private
  def map_params
  params.require(:map).permit(:address, :latitude, :longitude)
  end
end