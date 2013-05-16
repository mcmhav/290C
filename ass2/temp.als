abstract sig ActiveRecord { } 
sig Photo extends ActiveRecord { }
sig User extends ActiveRecord { }
sig Video extends ActiveRecord { }
sig Profile extends ActiveRecord { }
sig Video_0 in Video { } 
sig Role extends ActiveRecord { }
sig Tag extends ActiveRecord { }
sig Taggable in ActiveRecord { }

one sig PreState { 
	photos: set Photo, 
	users: set User, 
	videos: set Video, 
	profiles: set Profile, 
	video_0s: set Video_0, 
	roles: set Role, 
	tags: set Tag, 
	taggables: set Taggable, 

	taggable_tags: Taggable one -> set Tag,
	users_roles: User set -> set Role,
	videos_profile: Video_0 set -> set Profile,
	photos_profile: Photo set -> one Profile,
	user_profile: User one -> lone Profile,
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
