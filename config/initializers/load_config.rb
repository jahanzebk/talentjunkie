APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/talentjunkie.yml")[RAILS_ENV]
FLICKR_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/flickr.yml")[RAILS_ENV]
