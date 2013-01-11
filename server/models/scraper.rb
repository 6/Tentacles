class Scraper < ActiveRecord::Base
  validates_presence_of :title, :code

  # TODO move these methods to decorator (draper)
  def path
    if new_record?
      "/scrapers"
    else
      "/scrapers/#{id}"
    end
  end

  def edit_path
    "#{path}/edit"
  end

  def cancel_path
    if new_record?
      "/"
    else
      path
    end
  end
end
