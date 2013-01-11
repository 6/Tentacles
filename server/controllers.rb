class App < Sinatra::Base
  get '/' do
    haml :index
  end

  post '/scrapers' do
    @scraper = Scraper.new(:title => params[:title], :code => params[:code])
    if @scraper.save
      redirect @scraper.path
    else
      400
    end
  end
end
