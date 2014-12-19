class FaviconCacherWorker
  include Sidekiq::Worker

  def perform(page_id)
    page = Page.find(page_id)

    Favicon::Cacher.cache(page.id, page.url)
  end
end
