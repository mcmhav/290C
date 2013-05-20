class Profile < ActiveRecord::Base
    belongs_to :user
    has_many :photos, :dependent => :destroy
    has_many :videos, :dependent => :destroy
end