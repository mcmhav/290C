class User < ActiveRecord::Base
    has_and_belongs_to_many :roles
    has_one :profile, :dependent => :destroy
    has_many :photos, :through => :profile
end