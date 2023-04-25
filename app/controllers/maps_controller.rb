class MapsController < ApplicationController
  def search
  end

  def result
    x1 = params[:lat].to_f * Math::PI / 180
    y1 = params[:lng].to_f * Math::PI / 180

    arounds = []
    Map.all.each do |t|
        x2 = t.latitude * Math::PI / 180
        y2 = t.longitude * Math::PI / 180

        diff_y = (y1 - y2).abs
        
        calc1 = Math.cos(x2) * Math.sin(diff_y)
        calc2 = Math.cos(x1) * Math.sin(x2) - Math.sin(x1) * Math.cos(x2) * Math.cos(diff_y)
        
        numerator = Math.sqrt(calc1 ** 2 + calc2 ** 2)
        denominator = Math.sin(x1) * Math.sin(x2) + Math.cos(x1) * Math.cos(x2) * Math.cos(diff_y)
        degree = Math.atan2(numerator, denominator)

        α = 6378.137
        result = degree * α

        arounds.push( [result, t] )
    end

    @arounds = arounds.sort_by{ |s| s[0] }
end

  def index
      @maps = Map.all
      @map = Map.new
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