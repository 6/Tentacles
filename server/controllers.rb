class App < Sinatra::Base
  error ActiveRecord::RecordNotFound do
    404
  end

  get '/' do
    haml :index
  end

  get '/scrapers/new' do
    haml :'scrapers/new'
  end

  get '/scrapers/:id' do
    @scraper = Scraper.find(params[:id])
    haml :'scrapers/show'
  end

  post '/scrapers' do
    @scraper = Scraper.new(:title => params[:title], :code => params[:code])
    if @scraper.save
      redirect @scraper.path
    else
      400
    end
  end

  put '/scrapers/:id' do
    @scraper = Scraper.find(params[:id])
    if @scraper.update_attributes(:title => params[:title], :code => params[:code])
      redirect @scraper.path
    else
      400
    end
  end
end
