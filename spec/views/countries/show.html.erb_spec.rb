require 'spec_helper'

describe 'countries/show' do
  subject { rendered }

  context 'default view' do
    let(:country) { create(:country) }
    let(:page) { create(:page, title: nil) }
    let(:statuses) { create_pair(:status, country: country, page: page) }
    let(:status_groups) { statuses.group_by(&:value) }

    before do
      assign(:country, country)
      assign(:statuses, status_groups)

      render
    end

    it { should have_css('.media .media-body') }
    it { should have_css('.media-body .media-heading', text: country.name) }

    describe 'changed' do
      it { skip "should have_css 'h2', text: 'Changed since yesterday'" }
    end

    describe 'recent' do
      it { should have_css('h2', text: 'Recent') }
      it { should have_css('.list-group', count: status_groups.count) }

      it 'should link to statuses' do
        expect(rendered).to have_css(
          ".pages-status-success a.list-group-item[href*='#{status_path(statuses.first)}']",
          text: statuses.first.page_title,
          count: 1
        )
      end

      it 'should show the url for a page w/o a title' do
        expect(rendered).to have_css('.list-group-item', text: statuses.last.page_url)
      end
    end
  end
end
