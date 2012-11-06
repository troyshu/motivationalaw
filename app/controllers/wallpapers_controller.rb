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
    @wallpaper = Wallpaper.new(params[:wallpaper])

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
