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

  describe "GET /scrapers/:id" do
    def go!(id)
      get "/scrapers/#{id}"
    end

    context "with a valid ID" do
      it "returns ok" do
        scraper = FactoryGirl.create(:scraper)
        go!(scraper.id)
        last_response.should be_ok
      end
    end

    context "with an invalid ID" do
      it "returns not found" do
        invalid_id = 123
        go!(invalid_id)
        last_response.should be_not_found
      end
    end
  end

  describe "PUT /scrapers/:id" do
    let(:scraper) { FactoryGirl.create(:scraper) }

    def go!(params = {})
      put "/scrapers/#{scraper.id}", params
      scraper.reload
    end

    context "with valid params" do
      let :params do
        {
          :title => "Title",
          :code => "some code",
        }
      end

      it "updates scraper attributes" do
        go!(params)
        scraper.title.should == params[:title]
        scraper.code.should == params[:code]
      end

      it "redirects to the scraper path" do
        go!(params)
        last_response.should be_redirect
        follow_redirect!
        last_request.path.should == scraper.path
      end
    end

    context "with invalid params" do
      it "does not update Scraper attributes" do
        go!(:title => nil, :code => "new code")
        scraper.code.should_not == "new code"
      end

      it "returns bad request" do
        go!
        last_response.status.should == 400
      end
    end
  end
end
