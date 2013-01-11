class CreateScrapers < ActiveRecord::Migration
  def up
    create_table :scrapers do |t|
      t.string :title, :null => false
      t.text :code, :null => false

      t.timestamps
    end
  end

  def down
    drop_table :scrapers
  end
end
