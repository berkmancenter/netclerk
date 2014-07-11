require 'spec_helper'

describe 'statuses requests', :js => true do
  subject { page }

  describe ( 'get /' ) {
    # root should be statuses#index
    before { visit root_path }

    it {
      should have_css '.statuses-list'
    }
  }
end
