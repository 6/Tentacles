class App < Sinatra::Base
  error ActiveRecord::RecordNotFound do
    404
  end

  get '/' do
    @page = params[:page] || 1
    per_page = 10
    @page_count = (Scraper.count.to_f / per_page).ceil
    @scrapers = Scraper.order('updated_at DESC').limit(per_page).offset((@page - 1) * per_page).all
    haml :index
  end

  get '/scrapers/new' do
    @scraper = Scraper.new
    haml :'scrapers/new'
  end

  get '/scrapers/:id' do
    @scraper = Scraper.find(params[:id])
    haml :'scrapers/show'
  end

  get '/scrapers/:id/edit' do
    @scraper = Scraper.find(params[:id])
    haml :'scrapers/edit'
  end

  post '/scrapers' do
    @scraper = Scraper.new(:title => params[:title], :code => params[:code])
    if @scraper.save
      redirect @scraper.path
    else
      haml :'scrapers/new'
    end
  end

  post '/scrapers/:id' do
    @scraper = Scraper.find(params[:id])
    if @scraper.update_attributes(:title => params[:title], :code => params[:code])
      redirect @scraper.path
    else
      haml :'scrapers/edit'
    end
  end
end
