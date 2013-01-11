class Scraper < ActiveRecord::Base
  validates_presence_of :title, :code

  def path
    if new_record?
      "/scrapers"
    else
      "/scrapers/#{id}"
    end
  end
end
