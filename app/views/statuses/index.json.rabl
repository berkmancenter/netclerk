collection @changed
attributes :value, :delta
node(:created) { |t| t.created_at }
child :page do
  attributes :url, :title
end
child :country do
  attributes :name, :iso3
end

