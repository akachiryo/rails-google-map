class MapsController < ApplicationController

    def geocode
    # 住所をパラメーターから取得する
    address = params[:address]

    # YahooのジオコーダーAPIエンドポイントURLを作成する
    url = "https://map.yahooapis.jp/geocode/V1/geoCoder?appid=#{ENV['YAHOO_API_KEY']}&output=json&query=#{URI.encode_www_form_component(address)}"

    # APIリクエストを送信する
    response = RestClient.get(url)

    # 応答JSONから緯度経度を取得する
    result = JSON.parse(response.body)
    latitude = result['Feature'][0]['Geometry']['Coordinates'].split(',')[1].to_f
    longitude = result['Feature'][0]['Geometry']['Coordinates'].split(',')[0].to_f

    # 結果を返す
    render json: { latitude: latitude, longitude: longitude }
  end


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