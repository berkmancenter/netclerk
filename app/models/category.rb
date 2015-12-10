class Category < ActiveRecord::Base
  has_and_belongs_to_many :pages

  validates_uniqueness_of :name

  scope :has_pages, -> { joins(:pages).uniq }
end
