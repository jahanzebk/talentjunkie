class Tweet < ActiveRecord::Base
  named_scope :latest, :limit => 10
end