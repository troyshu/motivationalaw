require 'feedzirra'
require 'open-uri'
require 'fastimage'
require 'mini_magick'

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

  def extractImg(summary) 
    return summary.match(/<img src="(.*)"\s*\/>/)[1] #extract out the img url
  end

  # GET /wallpapers/new
  # GET /wallpapers/new.json
  def new
    @wallpaper = Wallpaper.new
    
    #select random image from /r/earthporn
    url = "http://imgur.com/r/earthporn/rss"
    feed = Feedzirra::Feed.fetch_and_parse(url)

    #logger.debug("feed contains #{feed.entries.count} entries")
    random_entry = feed.entries.shuffle.first
    #logger.debug("random entry url #{random_entry.url}")

    @random_img = extractImg(random_entry.summary)
    #logger.debug("random entry img url #{@random_img}")

    #TODO: MAKE SURE img has high enough resolution...
    img_size = FastImage.size(@random_img)
    
    min_width=700
    min_height=500
    while (img_size[0]<min_width or img_size[1]<min_height or img_size==nil) #make sure img is large enough
      random_entry = feed.entries.shuffle.first
      @random_img = extractImg(random_entry.summary)
      img_size = FastImage.size(@random_img)
    end
    logger.debug("image size #{img_size}")


    #save img to public directory temporarily
    logger.debug("rails root: #{Dir.pwd}")
    File.open("#{Dir.pwd}/public/temp.jpg", "wb") do |saved_file|
      # the following "open" is provided by open-uri
      open("#{@random_img}", 'rb') do |read_file|
        saved_file.write(read_file.read)
      end
    end

    #overlay quote in proper location: center of image x axis, below center of image y-axis, fits within a ... 200 px window?
    img = MiniMagick::Image.from_file("#{Dir.pwd}/public/temp.jpg")
 
    img.combine_options do |c|
       c.gravity 'center'
       c.draw 'text 0,50 \'BlahBlah wtf\''
       c.pointsize '30'
       c.font 'Comic.ttf'
       c.fill("#FFFFFF")
    end

    img.write("#{Dir.pwd}/public/temp_new.jpg")


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
