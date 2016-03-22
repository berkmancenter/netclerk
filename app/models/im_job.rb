class ImJob
  include ActiveModel::Validations
  
  attr_accessor :id, :url, :post_to

  validates_presence_of :id, :url, :post_to

  def self.from_message( message )
    job = ImJob.new
    job.id = message[ 'id' ]
    job.url = message[ 'url' ]
    job.post_to = message[ 'postTo' ]
    job
  end
end
