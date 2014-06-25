require 'spec_helper'

describe ( 'layouts/application' ) {
  subject { rendered }

  context ( 'default layout' ) {
    before {
      render 
    }

    it { should have_css 'header' }

    it { should have_css 'header .navbar' }

    it { should have_css '.navbar a' }
    
    it { should have_css 'a.navbar-brand', text: 'NetClerk' }

    it { should have_css '.navbar ul.nav' }

    it { should have_css 'ul.nav li a', text: 'Countries' }

    it { should have_css 'div.container' }

  }
}
