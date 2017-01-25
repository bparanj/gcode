class CreateDownloads < ActiveRecord::Migration[5.0]
  def change
    create_table :downloads do |t|
      t.string :ip
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
