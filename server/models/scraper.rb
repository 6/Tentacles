class Scraper < ActiveRecord::Base
  validates_presence_of :title, :code

  def path
    "/scrapers/#{id}"
  end
end
