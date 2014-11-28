namespace :netclerk do
  namespace :favicon do
    desc 'Update expired/missing favicons for all pages'
    task cache_all: :environment do
      cache_favicons(Page.all)
    end
  end
end

def cache_favicons(pages)
  pages.find_each { |page| FaviconCacherWorker.perform_async(page.id) }
end
