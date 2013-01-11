require 'spec_helper'

describe App do
  describe "POST /scrapers" do
    def go!(params = {})
      post '/scrapers', params
    end

    context "with valid params" do
      let :params do
        {
          :title => "Title",
          :code => "some code",
        }
      end

      it "creates a new Scraper" do
        expect { go!(params) }.to change { Scraper.count }.by(1)
        Scraper.last.title.should == params[:title]
        Scraper.last.code.should == params[:code]
      end

      it "redirects to the scraper path" do
        go!(params)
        last_response.should be_redirect
        follow_redirect!
        last_request.path.should == Scraper.last.path
      end
    end

    context "with invalid params" do
      it "does not create a new Scraper" do
        expect { go! }.not_to change { Scraper.count }
      end

      it "returns bad request" do
        go!
        last_response.status.should == 400
      end
    end
  end
end
