class Video < ActiveRecord::Base
    belongs_to :profile
    has_many :tags, :as => :taggable
end