class CreateWallpapers < ActiveRecord::Migration
  def change
    create_table :wallpapers do |t|
      t.string :url
      t.integer :quote_id

      t.timestamps
    end
  end
end
