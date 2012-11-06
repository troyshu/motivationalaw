require 'net/http'
require 'rexml/document'

class WallpapersController < ApplicationController
  # GET /wallpapers
  # GET /wallpapers.json
  def index
    @wallpapers = Wallpaper.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @wallpapers }
    end
  end

  # GET /wallpapers/1
  # GET /wallpapers/1.json
  def show
    @wallpaper = Wallpaper.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @wallpaper }
    end
  end

  # GET /wallpapers/new
  # GET /wallpapers/new.json
  def new
    @wallpaper = Wallpaper.new
    
    # get random flickr pic, and quote from db
    flickr_url = "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=90485e931f687a9b9c2a66bf58a3861a&text=landscape&safe_search=1&content_type=1&sort=interestingness-desc&per_page=20"
    flickr_xml = Net::HTTP.get_response(URI.parse(flickr_url))



    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @wallpaper }
    end
  end

  # GET /wallpapers/1/edit
  def edit
    @wallpaper = Wallpaper.find(params[:id])
  end

  # POST /wallpapers
  # POST /wallpapers.json
  def create
    @wallpaper = Wallpaper.new


    #give it a random quote
    random_quote = Quote.order("RANDOM()").first
    @wallpaper.quote_id = random_quote.id

    #get random flickr photo

    respond_to do |format|
      if @wallpaper.save
        format.html { redirect_to @wallpaper, notice: 'Wallpaper was successfully created.' }
        format.json { render json: @wallpaper, status: :created, location: @wallpaper }
      else
        format.html { render action: "new" }
        format.json { render json: @wallpaper.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /wallpapers/1
  # PUT /wallpapers/1.json
  def update
    @wallpaper = Wallpaper.find(params[:id])

    respond_to do |format|
      if @wallpaper.update_attributes(params[:wallpaper])
        format.html { redirect_to @wallpaper, notice: 'Wallpaper was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @wallpaper.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wallpapers/1
  # DELETE /wallpapers/1.json
  def destroy
    @wallpaper = Wallpaper.find(params[:id])
    @wallpaper.destroy

    respond_to do |format|
      format.html { redirect_to wallpapers_url }
      format.json { head :no_content }
    end
  end
end
