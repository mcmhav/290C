/**

3. Consider the Active Records data model shown in Figure 2 in the paper titled “Unbounded Data Model 
Veriﬁcation Using SMT Solvers.” Write two Alloy Models for this speciﬁcation using the two approaches 
described in Sections 4 and 4.1 of the paper titled “Bounded Veriﬁcation of Ruby on Rails Data Models.” 
Specify and check or simulate the following properties on this data model using the Alloy Analyzer: 
    1) A user’s photos are the same as the photos in that user’s proﬁle. 
    2) When a user is deleted, all the photos and videos that belong to that user are also deleted. 
    3) Eachproﬁle is associated with a user. 
    4) One user can only have one role. 
    5) A photo and a video can have the same tag. 
    6) Two users can have the same proﬁle.

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



abstract sig ActiveRecord { } 

sig User extends ActiveRecord { }
sig Role extends ActiveRecord { }
sig Profile extends ActiveRecord { }
sig Photo extends ActiveRecord { }
sig Video extends ActiveRecord { }
sig Tag extends ActiveRecord {
	
}

**/
abstract sig ActiveRecord { } 

sig User extends ActiveRecord { }
sig Role extends ActiveRecord { }
sig Profile extends ActiveRecord { }
sig Photo extends ActiveRecord { }
sig Video extends ActiveRecord { }
sig Tag extends ActiveRecord {

sig Video_0 in Video { } 
sig Taggable in ActiveRecord { }

one sig PreState { 
	users: set User, 
	roles: set Role, 
	profiles: set Profile,
	photos: set Photo,  
	videos: set Video, 
	tags: set Tag, 

	//video_0s: set Video_0, 
	taggables: set Taggable, 
	
	user_profile: User one -> lone Profile,

	taggable_tags: Taggable one -> set Tag,
	users_roles: User set -> set Role,
	videos_profile: Video_0 set -> set Profile,
	photos_profile: Photo set -> one Profile,
	
	profile_videos: Profile one -> set Video,

	User_photos = ~(profile_user).~(photos_profile),
}{
	all x: Photo | x in photos
	all x: User | x in users
	all x: Video | x in videos
	all x: Profile | x in profiles
	all x: Video_0 | x in video_0s
	all x: Role | x in roles
	all x: Tag | x in tags
	all x: Taggable | x in taggables
}

one sig PostState { 
	photos': set Photo, 
	users': set User, 
	videos': set Video, 
	profiles': set Profile, 
	video_0s': set Video_0, 
	roles': set Role, 
	tags': set Tag, 
	taggables': set Taggable, 

	taggable_tags': Taggable set -> set Tag,
	users_roles': User set -> set Role,
	videos_profile': Video_0 set -> set Profile,
	photos_profile': Photo set -> set Profile,
	user_profile': User set -> set Profile,
	profile_videos': Profile set -> set Video,

	User_photos' = ~(profile_user').~(photos_profile'),
}

/**
fact {   
	Photo in Taggable
	Video in Taggable
	all x0:Taggable | x0 in Photo or x0 in Video
	no User & Taggable
	no Profile & Taggable
	no Role & Taggable
	no Tag & Taggable
}   

pred deletePhoto [s: PreState, s': PostState, x:Photo] { 
	s'.photos' = s.photos - x
	s'.users' = s.users
	s'.videos' = s.videos
	s'.profiles' = s.profiles
	s'.roles' = s.roles
	s'.tags' = s.tags

	s'.taggable_tags' = s.taggable_tags
	s'.users_roles' = s.users_roles
	s'.videos_profile' = s.videos_profile
	s'.photos_profile' = s.photos_profile - (x <: s.photos_profile)
	s'.user_profile' = s.user_profile
	s'.profile_videos' = s.profile_videos

}

pred deleteUser [s: PreState, s': PostState, x:User] { 
	s'.photos' = s.photos - (s.photos_profile).(x.(s.user_profile))
	s'.users' = s.users - x
	s'.videos' = s.videos - (x.(s.user_profile)).(s.profile_videos)
	s'.profiles' = s.profiles - x.(s.user_profile)
	s'.roles' = s.roles
	s'.tags' = s.tags

	s'.taggable_tags' = s.taggable_tags
	s'.users_roles' = s.users_roles - (x <: s.users_roles)
	s'.videos_profile' = s.videos_profile
	s'.photos_profile' = s.photos_profile - ((s.photos_profile).(x.(s.user_profile)) <: s.photos_profile)
	s'.user_profile' = s.user_profile - (s.user_profile :> x.(s.user_profile))
	s'.profile_videos' = s.profile_videos - (s.profile_videos :> (x.(s.user_profile)).(s.profile_videos))

}

pred deleteVideo [s: PreState, s': PostState, x:Video] { 
	s'.photos' = s.photos
	s'.users' = s.users
	s'.videos' = s.videos - x
	s'.profiles' = s.profiles
	s'.roles' = s.roles
	s'.tags' = s.tags

	s'.taggable_tags' = s.taggable_tags
	s'.users_roles' = s.users_roles
	s'.videos_profile' = s.videos_profile
	s'.photos_profile' = s.photos_profile
	s'.user_profile' = s.user_profile
	s'.profile_videos' = s.profile_videos - (s.profile_videos :> x)

}

pred deleteProfile [s: PreState, s': PostState, x:Profile] { 
	s'.photos' = s.photos - (s.photos_profile).x
	s'.users' = s.users
	s'.videos' = s.videos - x.(s.profile_videos)
	s'.profiles' = s.profiles - x
	s'.roles' = s.roles
	s'.tags' = s.tags

	s'.taggable_tags' = s.taggable_tags
	s'.users_roles' = s.users_roles
	s'.videos_profile' = s.videos_profile
	s'.photos_profile' = s.photos_profile - ((s.photos_profile).x <: s.photos_profile)
	s'.user_profile' = s.user_profile - (s.user_profile :> x)
	s'.profile_videos' = s.profile_videos - (s.profile_videos :> x.(s.profile_videos))

}

pred deleteRole [s: PreState, s': PostState, x:Role] { 
	s'.photos' = s.photos
	s'.users' = s.users
	s'.videos' = s.videos
	s'.profiles' = s.profiles
	s'.roles' = s.roles - x
	s'.tags' = s.tags

	s'.taggable_tags' = s.taggable_tags
	s'.users_roles' = s.users_roles - (s.users_roles :> x)
	s'.videos_profile' = s.videos_profile
	s'.photos_profile' = s.photos_profile
	s'.user_profile' = s.user_profile
	s'.profile_videos' = s.profile_videos

}

pred deleteTag [s: PreState, s': PostState, x:Tag] { 
	s'.photos' = s.photos
	s'.users' = s.users
	s'.videos' = s.videos
	s'.profiles' = s.profiles
	s'.roles' = s.roles
	s'.tags' = s.tags - x

	s'.taggable_tags' = s.taggable_tags - (s.taggable_tags :> x)
	s'.users_roles' = s.users_roles
	s'.videos_profile' = s.videos_profile
	s'.photos_profile' = s.photos_profile
	s'.user_profile' = s.user_profile
	s'.profile_videos' = s.profile_videos

}
**/
