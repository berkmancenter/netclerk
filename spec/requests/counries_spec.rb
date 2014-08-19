require 'spec_helper'

describe 'countries requests', :js => true do
  subject { page }

  describe ( 'get /countries/:id' ) {
    let ( :irn ) { Country.find_by_name 'Iran'  }

    before { visit country_path( irn ) }

    it {
      should have_css '.media-heading', text: 'Iran'
    }

    it { should have_css 'svg.statuses-chart' }

    it { should have_css 'svg.statuses-chart rect', count: 3 }
  }
end
