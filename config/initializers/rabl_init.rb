require 'rabl'
Rabl.configure do |config|
  config.include_json_root = false
  config.include_child_root = false

  # read_multi is a new rabl feature that doesn't work
  # too well with nil child blocks
  config.use_read_multi = false
end

