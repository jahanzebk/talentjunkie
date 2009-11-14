class Diploma < ActiveRecord::Base
  belongs_to :degree
  belongs_to :user
end