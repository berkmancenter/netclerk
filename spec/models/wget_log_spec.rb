require 'spec_helper'

describe WgetLog do
  describe 'from_file' do
    let( :log ) {
      WgetLog.from_file( Rails.root.join( 'spec/fixtures/files/wget.log' ).to_s )
    }

    it 'should be valid' do
      log.should be_valid
      
      log.should respond_to :requests

      # use request_count instead of requests.count because the latter
      # only updates when saved to db, which we don't need to do
      log.should respond_to :request_count

    end

    it 'should have warc_path' do
      log.warc_path.should eq( 'C:/Users/rwestphal/Projects/berkmancenter/netclerk/public/content/53/53.warc' )
    end

    it 'should have finished_at' do
      log.finished_at.should eq( DateTime.new( 2016, 4, 1, 16, 57, 7 ) )
    end

    it 'should have total_time' do
      log.total_time.should eq( '11s' )
    end

    it 'should have file_count' do
      log.file_count.should eq( 242 )
    end

    it 'should have download_time' do
      log.download_time.should eq( '1.6s' )
    end

    it 'should have wget log requests' do
      log.request_count.should eq( 10 )
    end

    describe 'log request' do
      let ( :req ) {
        log.requests[ 0 ]
      }

      it 'should be valid' do
        req.should be_valid

        req.should respond_to :ip
      end

      it 'should have requested_at' do
        req.requested_at.should eq( DateTime.new( 2016, 4, 1, 16, 56, 56 ) )
      end

      it 'should have url' do
        req.url.should eq( 'http://nytimes.com/' )
      end

      it 'should have host' do
        req.host.should eq( 'nytimes.com' )
      end

      it 'should have ip' do
        req.ip.should eq( '170.149.159.130' )
      end

      it 'should have port' do
        req.port.should eq( 80 )
      end
    end
  end
end
