class App < Sinatra::Base
  get '/' do
    haml :index
  end

  get '/scrapers/:id' do
    begin
      @scraper = Scraper.find(params[:id])
    rescue
      404
    end
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
