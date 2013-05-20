/**

3. Consider the Active Records data model shown in Figure 2 in the paper titled “Unbounded Data Model 
Veriﬁcation Using SMT Solvers.” Write two Alloy Models for this speciﬁcation using the two approaches 
described in Sections 4 and 4.1 of the paper titled “Bounded Veriﬁcation of Ruby on Rails Data Models.” 
Specify and check or simulate the following properties on this data model using the Alloy Analyzer: 
D    1) A user’s photos are the same as the photos in that user’s proﬁle. 
D    2) When a user is deleted, all the photos and videos that belong to that user are also deleted. 
D    3) Eachproﬁle is associated with a user. 
D    4) One user can only have one role. 
D    5) A photo and a video can have the same tag. 
D    6) Two users can have the same proﬁle.

**/

abstract sig ActiveRecord { } 

sig User extends ActiveRecord { }
sig Role extends ActiveRecord { }
sig Profile extends ActiveRecord { }
sig Photo extends ActiveRecord { }
sig Video extends ActiveRecord { }
sig Tag extends ActiveRecord {
//	taggable: one Taggable
}

sig Taggable in ActiveRecord {
//	tag: lone Tag
}

one sig PreState { 
	users: set User, 
	roles: set Role, 
	profiles: set Profile,
	photos: set Photo,  
	videos: set Video, 
	tags: set Tag, 
	taggables: set Taggable, 

	//User
	users_roles: User set -> set Role,
	user_profile: User set -> lone Profile,

	//Profile
	//pofile_users: Profile one -> set User,
	photos_profile: Photo set -> one Profile,
	videos_profile: Video set -> one Profile,

	//Tag
	taggable_tags: Taggable set -> set Tag,

	//Relation
	User_photos = user_profile.~(photos_profile),
}{
	all x: Photo | x in photos
	all x: User | x in users
	all x: Video | x in videos
	all x: Profile | x in profiles
	all x: Role | x in roles
	all x: Tag | x in tags
	all x: Taggable | x in taggables
}

one sig PostState { 
	users': set User, 
	roles': set Role, 
	profiles': set Profile, 
	photos': set Photo, 
	videos': set Video, 
	tags': set Tag, 
	taggables': set Taggable, 

	//User
	users_roles': User set -> set Role,
	user_profile': User set -> set Profile,

	//Profile
	//pofile_users': Profile set -> set User,
	photos_profile': Photo set -> set Profile,
	videos_profile': Video set -> set Profile,

	//Tag
	taggable_tags': Taggable set -> set Tag,

	//Relation
	User_photos' = user_profile.~(photos_profile'),
}

fact {   
	Photo in Taggable
	Video in Taggable
	all x0:Taggable | x0 in Photo or x0 in Video
	no User & Taggable
	no Profile & Taggable
	no Role & Taggable
	no Tag & Taggable
}   

pred deleteUser [s: PreState, s': PostState, x:User] { 
	s'.users' = s.users - x
	s'.photos' = s.photos - (s.photos_profile).(x.(s.user_profile))
	s'.videos' = s.videos - (s.videos_profile).(x.(s.user_profile))
	s'.profiles' = s.profiles - x.(s.user_profile)
	s'.roles' = s.roles
	s'.tags' = s.tags

	s'.taggable_tags' = s.taggable_tags
	s'.users_roles' = s.users_roles - (x <: s.users_roles)
	s'.videos_profile' = s.videos_profile - ((s.videos_profile).(x.(s.user_profile)) <: s.videos_profile)
	s'.photos_profile' = s.photos_profile - ((s.photos_profile).(x.(s.user_profile)) <: s.photos_profile)
	s'.user_profile' = s.user_profile - (s.user_profile :> x.(s.user_profile))
}

run deleteUser for 5 ActiveRecord, exactly 2 User, exactly 1 Profile


pred deletePhoto [s: PreState, s': PostState, x:Photo] { 
	s'.users' = s.users
	s'.photos' = s.photos - x
	s'.videos' = s.videos
	s'.profiles' = s.profiles
	s'.roles' = s.roles
	s'.tags' = s.tags

	s'.taggable_tags' = s.taggable_tags
	s'.users_roles' = s.users_roles
	s'.videos_profile' = s.videos_profile
	s'.photos_profile' = s.photos_profile - (x <: s.photos_profile)
	s'.user_profile' = s.user_profile
}

pred deleteVideo [s: PreState, s': PostState, x:Video] { 
	s'.users' = s.users
	s'.photos' = s.photos
	s'.videos' = s.videos - x
	s'.profiles' = s.profiles
	s'.roles' = s.roles
	s'.tags' = s.tags

	s'.taggable_tags' = s.taggable_tags
	s'.users_roles' = s.users_roles
	s'.videos_profile' = s.videos_profile - (x <: s.videos_profile)
	s'.photos_profile' = s.photos_profile
	s'.user_profile' = s.user_profile
}

pred deleteProfile [s: PreState, s': PostState, x:Profile] { 
	s'.users' = s.users
	s'.photos' = s.photos - (s.photos_profile).x
	s'.videos' = s.videos - (s.videos_profile).x
	s'.profiles' = s.profiles - x
	s'.roles' = s.roles
	s'.tags' = s.tags

	s'.taggable_tags' = s.taggable_tags
	s'.users_roles' = s.users_roles
	s'.videos_profile' = s.videos_profile - ((s.videos_profile).x <: s.videos_profile)
	s'.photos_profile' = s.photos_profile - ((s.photos_profile).x <: s.photos_profile)
	s'.user_profile' = s.user_profile - (s.user_profile :> x)
}

pred deleteRole [s: PreState, s': PostState, x:Role] { 
	s'.users' = s.users
	s'.photos' = s.photos
	s'.videos' = s.videos
	s'.profiles' = s.profiles
	s'.roles' = s.roles - x
	s'.tags' = s.tags

	s'.taggable_tags' = s.taggable_tags
	s'.users_roles' = s.users_roles - (s.users_roles :> x)
	s'.videos_profile' = s.videos_profile
	s'.photos_profile' = s.photos_profile
	s'.user_profile' = s.user_profile
}

pred deleteTag [s: PreState, s': PostState, x:Tag] { 
	s'.users' = s.users
	s'.photos' = s.photos
	s'.videos' = s.videos
	s'.profiles' = s.profiles
	s'.roles' = s.roles
	s'.tags' = s.tags - x

	s'.taggable_tags' = s.taggable_tags - (s.taggable_tags :> x)
	s'.users_roles' = s.users_roles
	s'.videos_profile' = s.videos_profile
	s'.photos_profile' = s.photos_profile
	s'.user_profile' = s.user_profile
}

/**
Ruby on Rails model:

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

**/
