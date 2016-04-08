require 'spec_helper'

describe WgetLog do
  describe 'from_file' do
    let( :log ) {
      WgetLog.from_file( Rails.root.join( 'spec/fixtures/files/wget.log' ).to_s )
    }

    it {
      log.should be_valid
      
      log.should respond_to :requests

      # use request_count instead of requests.count because the latter
      # only updates when saved to db, which we don't need to do
      log.should respond_to :request_count
    }

    it { log.warc_path.should eq( 'C:/Users/rwestphal/Projects/berkmancenter/netclerk/public/content/53/53.warc' ) }

    it { log.finished_at.should eq( DateTime.new( 2016, 4, 1, 16, 57, 7 ) ) }

    it { log.total_time.should eq( '11s' ) }

    it { log.file_count.should eq( 242 ) }

    it { log.download_time.should eq( '1.6s' ) }

    it { log.request_count.should eq( 10 ) }

    describe 'log request' do
      context 'common attributes' do
        let ( :req ) { log.requests[ 0 ] }

        it {
          req.should be_valid
          req.should respond_to :ip
        }

        it { req.requested_at.should eq( DateTime.new( 2016, 4, 1, 16, 56, 56 ) ) }

        it { req.url.should eq( 'http://nytimes.com/' ) }

        it { req.host.should eq( 'nytimes.com' ) }

        it { req.ip.should eq( '170.149.159.130' ) }
      end

      context 'redirect' do
        let ( :req ) { log.requests[ 0 ] }

        it { req.response_code.should eq( 301 ) }

        it { req.is_redirect.should be true }

        it { req.redirect_location.should eq( 'http://www.nytimes.com/' ) }
      end

      context 'saved content' do
        let ( :req ) { log.requests[ 1 ] }

        it { req.specified_mime_type.should eq( 'text/html' ) }

        it { req.saved_path.should eq( 'C:/Users/rwestphal/Projects/berkmancenter/netclerk/public/content/53/nytimes.com/index.html' ) }

        it { req.saved_length.should eq( 178382 ) }

        it { req.download_speed.should eq( '2.40 MB/s' ) }
      end

      describe 'specified length' do
        context 'no length' do
          let ( :req ) { log.requests[ 0 ] }
          it { req.specified_length.should eq( 0 ) }
        end

        context 'unspecified' do
          let ( :req ) { log.requests[ 1 ] }
          it { req.specified_length.should eq( nil ) }
        end

        context 'specified' do
          let ( :req ) { log.requests[ 2 ] }
          it { req.specified_length.should eq( 1029 ) }
        end
      end
    end
  end
end
