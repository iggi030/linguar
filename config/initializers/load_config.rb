MAPS_KEY = YAML.load_file("#{RAILS_ROOT}/config/gmaps_api_key.yml")[RAILS_ENV]
TRACKING = YAML.load_file("#{RAILS_ROOT}/config/tracking.yml")[RAILS_ENV]
