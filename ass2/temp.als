abstract sig ActiveRecord { } 
sig User extends ActiveRecord { }
sig Photo extends ActiveRecord { }
sig Video extends ActiveRecord { }
sig Profile extends ActiveRecord { }
sig Role extends ActiveRecord { }
sig Tag extends ActiveRecord { }
sig Taggable in ActiveRecord { }

one sig PreState { 
	users: set User, 
	photos: set Photo, 
	videos: set Video, 
	profiles: set Profile, 
	roles: set Role, 
	tags: set Tag, 
	taggables: set Taggable, 

	taggable_tags: Taggable one -> set Tag,
	users_roles: User set -> set Role,
	videos_profile: Video set -> one Profile,
	photos_profile: Photo set -> one Profile,
	user_profile: User one -> lone Profile,

	User_photos = ~(profile_user).~(photos_profile),
}{
	all x: User | x in users
	all x: Photo | x in photos
	all x: Video | x in videos
	all x: Profile | x in profiles
	all x: Role | x in roles
	all x: Tag | x in tags
	all x: Taggable | x in taggables
}

one sig PostState { 
	users': set User, 
	photos': set Photo, 
	videos': set Video, 
	profiles': set Profile, 
	roles': set Role, 
	tags': set Tag, 
	taggables': set Taggable, 

	taggable_tags': Taggable set -> set Tag,
	users_roles': User set -> set Role,
	videos_profile': Video set -> set Profile,
	photos_profile': Photo set -> set Profile,
	user_profile': User set -> set Profile,

	User_photos' = ~(profile_user').~(photos_profile'),
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
