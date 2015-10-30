require 'spec_helper'

describe 'statuses/availability' do
  subject { rendered }

  let(:status) { create(:status) }

  before { render partial: 'statuses/availability', object: status }

  it { should have_css 'span', text: "#{Status::VALUES[status.value].capitalize}" }
  it { should_not have_css 'img[src="http://www.google.com/s2/favicons?domain=www.whitehouse.gov"]' }
  it { should_not have_css 'b', status.country_name }
end
