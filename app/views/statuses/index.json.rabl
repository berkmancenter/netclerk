collection @changed
attributes :value, :delta
child :page do
  attributes :url, :title
end
child :country do
  attributes :name, :iso3
end

