require 'spec_helper'

describe WgetLog do
  describe 'from_file' do
    let( :log ) {
      WgetLog.from_file( Rails.root.join( 'spec/fixtures/files/wget.log' ).to_s )
    }

    it 'should be valid' do
      log.should be_valid
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
  end
end
