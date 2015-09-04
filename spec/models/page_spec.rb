require 'spec_helper'

describe Page do
  it { should belong_to :category }
  it { should have_many :statuses }
  it { should ensure_length_of(:url).is_at_most(2048) }

  context( 'valid attributes' ) {
    let( :twitter ) { Page.find_by_title 'Twitter' }

    it {
      twitter.should be_valid

      twitter.should respond_to :url
      twitter.should respond_to :title
      twitter.should respond_to :category
    }

    it {
      twitter.category.name.should eq 'social'
    }
  }

  context( 'trailing slash removed' ) {
    let( :p ) { Page.new url: 'http://trailing-slash.com/' }

    it {
      p.should be_valid
    }

    it {
      p.valid?
      p.url[-1].should_not eq( '/' )
    }
  }

  describe( 'create_proxy_requests' ) {
    let( :p ) { Page.find_by_title 'The White House' }

    it ( 'should make requests' ) {
      skip 'hard to keep working proxy up to date for test'
      # may remove this test & create_proxy_requests function now that we have sidekiq

      expect {
        p.create_proxy_requests
      }.to change {
        Request.count
      }.by( Proxy.count )
    }
  }

  it 'has a valid factory' do
    expect(build(:page)).to be_valid
  end

  describe( 'baseline_content' ) {
    let( :p ) { Page.find_by_title 'The White House' }

    before {
      stub_request(
        :get, "http://www.whitehouse.gov/"
      ).with(
        :headers => {
          'Accept'=>'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Accept-Language'=>'en-US,en;q=0.8',
          'Connection'=>'close',
          'User-Agent'=>'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36'
        }
      ).to_return(:status => 200, :body => "The Home Page for the White House of the United States.", :headers => {})
      Rails.cache.delete p.url
    }

    it {
      p.baseline_content.should_not be_nil
      expect(Rails.cache.exist?( p.url )).to be(true)
    }
  }
end
