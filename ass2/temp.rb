class User < ActiveRecord::Base
    has_and_belongs_to_many :roles
    has_one :profile, :dependent => :destroy
    has_many :photos, :through => :profile
end

class Role < ActiveRecord::Base
    has_and_belongs_to_many :users
end

class Profile < ActiveRecord::Base
    belongs_to :user
    has_many :photos, :dependent => :destroy
    has_many :videos, :dependent => :destroy, :conditions => "format=’mp4’"
end

class Photo < ActiveRecord::Base
    belongs_to :profile
    has_many :tags, :as => :taggable
end

class Video < ActiveRecord::Base
    belongs_to :profile
    has_many :tags, :as => :taggable
end

class Tag < ActiveRecord::Base
    belongs_to :taggable, :polymorphic => true
end