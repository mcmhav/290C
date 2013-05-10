abstract sig ActiveRecord { } 
sig Membership extends ActiveRecord { }
sig Event extends ActiveRecord { }
sig Tagging extends ActiveRecord { }
sig Comment extends Content { }
sig AssignedAsset extends ActiveRecord { }
sig Article extends Content { }
sig Comment_0 in Comment { } 
sig UnapprovedComment_1 in Comment { } 
sig Asset_2 in Asset { } 
sig AssignedSection extends ActiveRecord { }
sig Section extends ActiveRecord { }
sig Asset extends ActiveRecord { }
sig User extends ActiveRecord { }
sig Article_3 in Article { } 
sig Content extends ActiveRecord { }
sig Site extends ActiveRecord { }
sig Asset_4 in Asset { } 
sig Admin_5 in User { } 
sig Comment_6 in Comment { } 
sig UnapprovedComment_7 in Comment { } 
sig Tag extends ActiveRecord { }
sig CachedPage extends ActiveRecord { }
sig Site_8 in Site { } 
sig Taggable in ActiveRecord { }

one sig PreState { 
	memberships: set Membership, 
	events: set Event, 
	taggings: set Tagging, 
	comments: set Comment, 
	assignedassets: set AssignedAsset, 
	articles: set Article, 
	comment_0s: set Comment_0, 
	unapprovedcomment_1s: set UnapprovedComment_1, 
	asset_2s: set Asset_2, 
	assignedsections: set AssignedSection, 
	sections: set Section, 
	assets: set Asset, 
	users: set User, 
	article_3s: set Article_3, 
	contents: set Content, 
	sites: set Site, 
	asset_4s: set Asset_4, 
	admin_5s: set Admin_5, 
	comment_6s: set Comment_6, 
	unapprovedcomment_7s: set UnapprovedComment_7, 
	tags: set Tag, 
	cachedpages: set CachedPage, 
	site_8s: set Site_8, 
	taggables: set Taggable, 

	site_cachedpage: Site_8 one -> one CachedPage,
	taggings_tag: Tagging set -> one Tag,
	unapproved_comments_site: UnapprovedComment_7 set -> set Site,
	comments_site: Comment_6 set -> set Site,
	memberships_site: Membership set -> one Site,
	assets_site: Asset_4 set -> set Site,
	events_site: Event set -> one Site,
	sections_site: Section set -> one Site,
	site_contents: Site one -> set Content,
	user_contents: User one -> set Content,
	memberships_user: Membership set -> one User,
	articles_user: Article_3 set -> set User,
	assigned_assets_asset: AssignedAsset set -> one Asset,
	site_assets: Site one -> set Asset,
	assigned_sections_section: AssignedSection set -> one Section,
	article_assigned_sections: Article one -> set AssignedSection,
	assigned_assets_article: AssignedAsset set -> one Article,
	asset_assigned_assets: Asset one -> set AssignedAsset,
	article_assigned_assets: Article one -> set AssignedAsset,
	unapproved_comments_article: UnapprovedComment_1 set -> set Article,
	comments_article: Comment_0 set -> set Article,
	events_article: Event set -> one Article,
	updater_articles: User one -> set Article,
	event_comment: Event lone -> one Comment,
	article_comments: Article one -> set Comment,
	user_events: User one -> set Event,

	Article_sections = article_assigned_sections.assigned_sections_section,
	Article_assets = article_assigned_assets.~(asset_assigned_assets),
	Section_articles = ~(assigned_sections_section).~(article_assigned_sections),
	User_sites = ~(memberships_user).memberships_site,
}{
	all x: Membership | x in memberships
	all x: Event | x in events
	all x: Tagging | x in taggings
	all x: Comment | x in comments
	all x: AssignedAsset | x in assignedassets
	all x: Article | x in articles
	all x: Comment_0 | x in comment_0s
	all x: UnapprovedComment_1 | x in unapprovedcomment_1s
	all x: Asset_2 | x in asset_2s
	all x: AssignedSection | x in assignedsections
	all x: Section | x in sections
	all x: Asset | x in assets
	all x: User | x in users
	all x: Article_3 | x in article_3s
	all x: Content | x in contents
	all x: Site | x in sites
	all x: Asset_4 | x in asset_4s
	all x: Admin_5 | x in admin_5s
	all x: Comment_6 | x in comment_6s
	all x: UnapprovedComment_7 | x in unapprovedcomment_7s
	all x: Tag | x in tags
	all x: CachedPage | x in cachedpages
	all x: Site_8 | x in site_8s
	all x: Taggable | x in taggables
}

one sig PostState { 
	memberships': set Membership, 
	events': set Event, 
	taggings': set Tagging, 
	comments': set Comment, 
	assignedassets': set AssignedAsset, 
	articles': set Article, 
	comment_0s': set Comment_0, 
	unapprovedcomment_1s': set UnapprovedComment_1, 
	asset_2s': set Asset_2, 
	assignedsections': set AssignedSection, 
	sections': set Section, 
	assets': set Asset, 
	users': set User, 
	article_3s': set Article_3, 
	contents': set Content, 
	sites': set Site, 
	asset_4s': set Asset_4, 
	admin_5s': set Admin_5, 
	comment_6s': set Comment_6, 
	unapprovedcomment_7s': set UnapprovedComment_7, 
	tags': set Tag, 
	cachedpages': set CachedPage, 
	site_8s': set Site_8, 
	taggables': set Taggable, 

	site_cachedpage': Site_8 set -> set CachedPage,
	taggings_tag': Tagging set -> set Tag,
	unapproved_comments_site': UnapprovedComment_7 set -> set Site,
	comments_site': Comment_6 set -> set Site,
	memberships_site': Membership set -> set Site,
	assets_site': Asset_4 set -> set Site,
	events_site': Event set -> set Site,
	sections_site': Section set -> set Site,
	site_contents': Site set -> set Content,
	user_contents': User set -> set Content,
	memberships_user': Membership set -> set User,
	articles_user': Article_3 set -> set User,
	assigned_assets_asset': AssignedAsset set -> set Asset,
	site_assets': Site set -> set Asset,
	assigned_sections_section': AssignedSection set -> set Section,
	article_assigned_sections': Article set -> set AssignedSection,
	article_assigned_assets': Article set -> set AssignedAsset,
	asset_assigned_assets': Asset set -> set AssignedAsset,
	assigned_assets_article': AssignedAsset set -> set Article,
	unapproved_comments_article': UnapprovedComment_1 set -> set Article,
	comments_article': Comment_0 set -> set Article,
	events_article': Event set -> set Article,
	updater_articles': User set -> set Article,
	event_comment': Event set -> set Comment,
	article_comments': Article set -> set Comment,
	user_events': User set -> set Event,

	Article_sections' = article_assigned_sections'.assigned_sections_section',
	Article_assets' = article_assigned_assets'.~(asset_assigned_assets'),
	Section_articles' = ~(assigned_sections_section').~(article_assigned_sections'),
	User_sites' = ~(memberships_user').memberships_site',
}


pred deleteMembership [s: PreState, s': PostState, x:Membership] { 
	s'.memberships' = s.memberships - x
	s'.events' = s.events
	s'.taggings' = s.taggings
	s'.comments' = s.comments
	s'.assignedassets' = s.assignedassets
	s'.articles' = s.articles
	s'.assignedsections' = s.assignedsections
	s'.sections' = s.sections
	s'.assets' = s.assets
	s'.users' = s.users
	s'.contents' = s.contents
	s'.sites' = s.sites
	s'.tags' = s.tags
	s'.cachedpages' = s.cachedpages

	s'.site_cachedpage' = s.site_cachedpage
	s'.taggings_tag' = s.taggings_tag
	s'.unapproved_comments_site' = s.unapproved_comments_site
	s'.comments_site' = s.comments_site
	s'.memberships_site' = s.memberships_site - (x <: s.memberships_site)
	s'.assets_site' = s.assets_site
	s'.events_site' = s.events_site
	s'.sections_site' = s.sections_site
	s'.site_contents' = s.site_contents
	s'.user_contents' = s.user_contents
	s'.memberships_user' = s.memberships_user - (x <: s.memberships_user)
	s'.articles_user' = s.articles_user
	s'.assigned_assets_asset' = s.assigned_assets_asset
	s'.site_assets' = s.site_assets
	s'.assigned_sections_section' = s.assigned_sections_section
	s'.article_assigned_sections' = s.article_assigned_sections
	s'.assigned_assets_article' = s.assigned_assets_article
	s'.unapproved_comments_article' = s.unapproved_comments_article
	s'.comments_article' = s.comments_article
	s'.events_article' = s.events_article
	s'.updater_articles' = s.updater_articles
	s'.event_comment' = s.event_comment
	s'.article_comments' = s.article_comments
	s'.user_events' = s.user_events

}

pred deleteEvent [s: PreState, s': PostState, x:Event] { 
	s'.memberships' = s.memberships
	s'.events' = s.events - x
	s'.taggings' = s.taggings
	s'.comments' = s.comments
	s'.assignedassets' = s.assignedassets
	s'.articles' = s.articles
	s'.assignedsections' = s.assignedsections
	s'.sections' = s.sections
	s'.assets' = s.assets
	s'.users' = s.users
	s'.contents' = s.contents
	s'.sites' = s.sites
	s'.tags' = s.tags
	s'.cachedpages' = s.cachedpages

	s'.site_cachedpage' = s.site_cachedpage
	s'.taggings_tag' = s.taggings_tag
	s'.unapproved_comments_site' = s.unapproved_comments_site
	s'.comments_site' = s.comments_site
	s'.memberships_site' = s.memberships_site
	s'.assets_site' = s.assets_site
	s'.events_site' = s.events_site - (x <: s.events_site)
	s'.sections_site' = s.sections_site
	s'.site_contents' = s.site_contents
	s'.user_contents' = s.user_contents
	s'.memberships_user' = s.memberships_user
	s'.articles_user' = s.articles_user
	s'.assigned_assets_asset' = s.assigned_assets_asset
	s'.site_assets' = s.site_assets
	s'.assigned_sections_section' = s.assigned_sections_section
	s'.article_assigned_sections' = s.article_assigned_sections
	s'.assigned_assets_article' = s.assigned_assets_article
	s'.unapproved_comments_article' = s.unapproved_comments_article
	s'.comments_article' = s.comments_article
	s'.events_article' = s.events_article - (x <: s.events_article)
	s'.updater_articles' = s.updater_articles
	s'.event_comment' = s.event_comment - (x <: s.event_comment)
	s'.article_comments' = s.article_comments
	s'.user_events' = s.user_events - (s.user_events :> x)

}

pred deleteTagging [s: PreState, s': PostState, x:Tagging] { 
	s'.memberships' = s.memberships
	s'.events' = s.events
	s'.taggings' = s.taggings - x
	s'.comments' = s.comments
	s'.assignedassets' = s.assignedassets
	s'.articles' = s.articles
	s'.assignedsections' = s.assignedsections
	s'.sections' = s.sections
	s'.assets' = s.assets
	s'.users' = s.users
	s'.contents' = s.contents
	s'.sites' = s.sites
	s'.tags' = s.tags
	s'.cachedpages' = s.cachedpages

	s'.site_cachedpage' = s.site_cachedpage
	s'.taggings_tag' = s.taggings_tag - (x <: s.taggings_tag)
	s'.unapproved_comments_site' = s.unapproved_comments_site
	s'.comments_site' = s.comments_site
	s'.memberships_site' = s.memberships_site
	s'.assets_site' = s.assets_site
	s'.events_site' = s.events_site
	s'.sections_site' = s.sections_site
	s'.site_contents' = s.site_contents
	s'.user_contents' = s.user_contents
	s'.memberships_user' = s.memberships_user
	s'.articles_user' = s.articles_user
	s'.assigned_assets_asset' = s.assigned_assets_asset
	s'.site_assets' = s.site_assets
	s'.assigned_sections_section' = s.assigned_sections_section
	s'.article_assigned_sections' = s.article_assigned_sections
	s'.assigned_assets_article' = s.assigned_assets_article
	s'.unapproved_comments_article' = s.unapproved_comments_article
	s'.comments_article' = s.comments_article
	s'.events_article' = s.events_article
	s'.updater_articles' = s.updater_articles
	s'.event_comment' = s.event_comment
	s'.article_comments' = s.article_comments
	s'.user_events' = s.user_events

}

pred deleteComment [s: PreState, s': PostState, x:Comment] { 
	s'.memberships' = s.memberships
	s'.events' = s.events - (s.event_comment).x
	s'.taggings' = s.taggings
	s'.comments' = s.comments - x
	s'.assignedassets' = s.assignedassets
	s'.articles' = s.articles
	s'.assignedsections' = s.assignedsections
	s'.sections' = s.sections
	s'.assets' = s.assets
	s'.users' = s.users
	s'.contents' = s.contents
	s'.sites' = s.sites
	s'.tags' = s.tags
	s'.cachedpages' = s.cachedpages

	s'.site_cachedpage' = s.site_cachedpage
	s'.taggings_tag' = s.taggings_tag
	s'.unapproved_comments_site' = s.unapproved_comments_site
	s'.comments_site' = s.comments_site
	s'.memberships_site' = s.memberships_site
	s'.assets_site' = s.assets_site
	s'.events_site' = s.events_site - ((s.event_comment).x <: s.events_site)
	s'.sections_site' = s.sections_site
	s'.site_contents' = s.site_contents
	s'.user_contents' = s.user_contents
	s'.memberships_user' = s.memberships_user
	s'.articles_user' = s.articles_user
	s'.assigned_assets_asset' = s.assigned_assets_asset
	s'.site_assets' = s.site_assets
	s'.assigned_sections_section' = s.assigned_sections_section
	s'.article_assigned_sections' = s.article_assigned_sections
	s'.assigned_assets_article' = s.assigned_assets_article
	s'.unapproved_comments_article' = s.unapproved_comments_article
	s'.comments_article' = s.comments_article
	s'.events_article' = s.events_article - ((s.event_comment).x <: s.events_article)
	s'.updater_articles' = s.updater_articles
	s'.event_comment' = s.event_comment - ((s.event_comment).x <: s.event_comment)
	s'.article_comments' = s.article_comments - (s.article_comments :> x)
	s'.user_events' = s.user_events - (s.user_events :> (s.event_comment).x)

}

pred deleteAssignedAsset [s: PreState, s': PostState, x:AssignedAsset] { 
	s'.memberships' = s.memberships
	s'.events' = s.events
	s'.taggings' = s.taggings
	s'.comments' = s.comments
	s'.assignedassets' = s.assignedassets - x
	s'.articles' = s.articles
	s'.assignedsections' = s.assignedsections
	s'.sections' = s.sections
	s'.assets' = s.assets
	s'.users' = s.users
	s'.contents' = s.contents
	s'.sites' = s.sites
	s'.tags' = s.tags
	s'.cachedpages' = s.cachedpages

	s'.site_cachedpage' = s.site_cachedpage
	s'.taggings_tag' = s.taggings_tag
	s'.unapproved_comments_site' = s.unapproved_comments_site
	s'.comments_site' = s.comments_site
	s'.memberships_site' = s.memberships_site
	s'.assets_site' = s.assets_site
	s'.events_site' = s.events_site
	s'.sections_site' = s.sections_site
	s'.site_contents' = s.site_contents
	s'.user_contents' = s.user_contents
	s'.memberships_user' = s.memberships_user
	s'.articles_user' = s.articles_user
	s'.assigned_assets_asset' = s.assigned_assets_asset - (x <: s.assigned_assets_asset)
	s'.site_assets' = s.site_assets
	s'.assigned_sections_section' = s.assigned_sections_section
	s'.article_assigned_sections' = s.article_assigned_sections
	s'.assigned_assets_article' = s.assigned_assets_article - (x <: s.assigned_assets_article)
	s'.unapproved_comments_article' = s.unapproved_comments_article
	s'.comments_article' = s.comments_article
	s'.events_article' = s.events_article
	s'.updater_articles' = s.updater_articles
	s'.event_comment' = s.event_comment
	s'.article_comments' = s.article_comments
	s'.user_events' = s.user_events

}

pred deleteArticle [s: PreState, s': PostState, x:Article] { 
	s'.memberships' = s.memberships
	s'.events' = s.events - (s.events_article).x
	s'.taggings' = s.taggings
	s'.comments' = s.comments
	s'.assignedassets' = s.assignedassets - (s.assigned_assets_article).x
	s'.articles' = s.articles - x
	s'.assignedsections' = s.assignedsections - x.(s.article_assigned_sections)
	s'.sections' = s.sections
	s'.assets' = s.assets
	s'.users' = s.users
	s'.contents' = s.contents
	s'.sites' = s.sites
	s'.tags' = s.tags
	s'.cachedpages' = s.cachedpages

	s'.site_cachedpage' = s.site_cachedpage
	s'.taggings_tag' = s.taggings_tag
	s'.unapproved_comments_site' = s.unapproved_comments_site
	s'.comments_site' = s.comments_site
	s'.memberships_site' = s.memberships_site
	s'.assets_site' = s.assets_site
	s'.events_site' = s.events_site - ((s.events_article).x <: s.events_site)
	s'.sections_site' = s.sections_site
	s'.site_contents' = s.site_contents
	s'.user_contents' = s.user_contents
	s'.memberships_user' = s.memberships_user
	s'.articles_user' = s.articles_user
	s'.assigned_assets_asset' = s.assigned_assets_asset - ((s.assigned_assets_article).x <: s.assigned_assets_asset)
	s'.site_assets' = s.site_assets
	s'.assigned_sections_section' = s.assigned_sections_section - (x.(s.article_assigned_sections) <: s.assigned_sections_section)
	s'.article_assigned_sections' = s.article_assigned_sections - (s.article_assigned_sections :> x.(s.article_assigned_sections))
	s'.assigned_assets_article' = s.assigned_assets_article - ((s.assigned_assets_article).x <: s.assigned_assets_article)
	s'.unapproved_comments_article' = s.unapproved_comments_article
	s'.comments_article' = s.comments_article
	s'.events_article' = s.events_article - ((s.events_article).x <: s.events_article)
	s'.updater_articles' = s.updater_articles - (s.updater_articles :> x)
	s'.event_comment' = s.event_comment - ((s.events_article).x <: s.event_comment)
	s'.article_comments' = s.article_comments
	s'.user_events' = s.user_events - (s.user_events :> (s.events_article).x)

}

pred deleteAssignedSection [s: PreState, s': PostState, x:AssignedSection] { 
	s'.memberships' = s.memberships
	s'.events' = s.events
	s'.taggings' = s.taggings
	s'.comments' = s.comments
	s'.assignedassets' = s.assignedassets
	s'.articles' = s.articles
	s'.assignedsections' = s.assignedsections - x
	s'.sections' = s.sections
	s'.assets' = s.assets
	s'.users' = s.users
	s'.contents' = s.contents
	s'.sites' = s.sites
	s'.tags' = s.tags
	s'.cachedpages' = s.cachedpages

	s'.site_cachedpage' = s.site_cachedpage
	s'.taggings_tag' = s.taggings_tag
	s'.unapproved_comments_site' = s.unapproved_comments_site
	s'.comments_site' = s.comments_site
	s'.memberships_site' = s.memberships_site
	s'.assets_site' = s.assets_site
	s'.events_site' = s.events_site
	s'.sections_site' = s.sections_site
	s'.site_contents' = s.site_contents
	s'.user_contents' = s.user_contents
	s'.memberships_user' = s.memberships_user
	s'.articles_user' = s.articles_user
	s'.assigned_assets_asset' = s.assigned_assets_asset
	s'.site_assets' = s.site_assets
	s'.assigned_sections_section' = s.assigned_sections_section - (x <: s.assigned_sections_section)
	s'.article_assigned_sections' = s.article_assigned_sections - (s.article_assigned_sections :> x)
	s'.assigned_assets_article' = s.assigned_assets_article
	s'.unapproved_comments_article' = s.unapproved_comments_article
	s'.comments_article' = s.comments_article
	s'.events_article' = s.events_article
	s'.updater_articles' = s.updater_articles
	s'.event_comment' = s.event_comment
	s'.article_comments' = s.article_comments
	s'.user_events' = s.user_events

}

pred deleteSection [s: PreState, s': PostState, x:Section] { 
	s'.memberships' = s.memberships
	s'.events' = s.events
	s'.taggings' = s.taggings
	s'.comments' = s.comments
	s'.assignedassets' = s.assignedassets
	s'.articles' = s.articles
	s'.assignedsections' = s.assignedsections - (s.assigned_sections_section).x
	s'.sections' = s.sections - x
	s'.assets' = s.assets
	s'.users' = s.users
	s'.contents' = s.contents
	s'.sites' = s.sites
	s'.tags' = s.tags
	s'.cachedpages' = s.cachedpages

	s'.site_cachedpage' = s.site_cachedpage
	s'.taggings_tag' = s.taggings_tag
	s'.unapproved_comments_site' = s.unapproved_comments_site
	s'.comments_site' = s.comments_site
	s'.memberships_site' = s.memberships_site
	s'.assets_site' = s.assets_site
	s'.events_site' = s.events_site
	s'.sections_site' = s.sections_site - (x <: s.sections_site)
	s'.site_contents' = s.site_contents
	s'.user_contents' = s.user_contents
	s'.memberships_user' = s.memberships_user
	s'.articles_user' = s.articles_user
	s'.assigned_assets_asset' = s.assigned_assets_asset
	s'.site_assets' = s.site_assets
	s'.assigned_sections_section' = s.assigned_sections_section - ((s.assigned_sections_section).x <: s.assigned_sections_section)
	s'.article_assigned_sections' = s.article_assigned_sections - (s.article_assigned_sections :> (s.assigned_sections_section).x)
	s'.assigned_assets_article' = s.assigned_assets_article
	s'.unapproved_comments_article' = s.unapproved_comments_article
	s'.comments_article' = s.comments_article
	s'.events_article' = s.events_article
	s'.updater_articles' = s.updater_articles
	s'.event_comment' = s.event_comment
	s'.article_comments' = s.article_comments
	s'.user_events' = s.user_events

}

pred deleteAsset [s: PreState, s': PostState, x:Asset] { 
	s'.memberships' = s.memberships
	s'.events' = s.events
	s'.taggings' = s.taggings
	s'.comments' = s.comments
	s'.assignedassets' = s.assignedassets - (s.assigned_assets_asset).x
	s'.articles' = s.articles
	s'.assignedsections' = s.assignedsections
	s'.sections' = s.sections
	s'.assets' = s.assets - x
	s'.users' = s.users
	s'.contents' = s.contents
	s'.sites' = s.sites
	s'.tags' = s.tags
	s'.cachedpages' = s.cachedpages

	s'.site_cachedpage' = s.site_cachedpage
	s'.taggings_tag' = s.taggings_tag
	s'.unapproved_comments_site' = s.unapproved_comments_site
	s'.comments_site' = s.comments_site
	s'.memberships_site' = s.memberships_site
	s'.assets_site' = s.assets_site
	s'.events_site' = s.events_site
	s'.sections_site' = s.sections_site
	s'.site_contents' = s.site_contents
	s'.user_contents' = s.user_contents
	s'.memberships_user' = s.memberships_user
	s'.articles_user' = s.articles_user
	s'.assigned_assets_asset' = s.assigned_assets_asset - ((s.assigned_assets_asset).x <: s.assigned_assets_asset)
	s'.site_assets' = s.site_assets - (s.site_assets :> x)
	s'.assigned_sections_section' = s.assigned_sections_section
	s'.article_assigned_sections' = s.article_assigned_sections
	s'.assigned_assets_article' = s.assigned_assets_article - ((s.assigned_assets_asset).x <: s.assigned_assets_article)
	s'.unapproved_comments_article' = s.unapproved_comments_article
	s'.comments_article' = s.comments_article
	s'.events_article' = s.events_article
	s'.updater_articles' = s.updater_articles
	s'.event_comment' = s.event_comment
	s'.article_comments' = s.article_comments
	s'.user_events' = s.user_events

}

pred deleteUser [s: PreState, s': PostState, x:User] { 
	s'.memberships' = s.memberships - (s.memberships_user).x
	s'.events' = s.events
	s'.taggings' = s.taggings
	s'.comments' = s.comments
	s'.assignedassets' = s.assignedassets
	s'.articles' = s.articles
	s'.assignedsections' = s.assignedsections
	s'.sections' = s.sections
	s'.assets' = s.assets
	s'.users' = s.users - x
	s'.contents' = s.contents
	s'.sites' = s.sites
	s'.tags' = s.tags
	s'.cachedpages' = s.cachedpages

	s'.site_cachedpage' = s.site_cachedpage
	s'.taggings_tag' = s.taggings_tag
	s'.unapproved_comments_site' = s.unapproved_comments_site
	s'.comments_site' = s.comments_site
	s'.memberships_site' = s.memberships_site - ((s.memberships_user).x <: s.memberships_site)
	s'.assets_site' = s.assets_site
	s'.events_site' = s.events_site
	s'.sections_site' = s.sections_site
	s'.site_contents' = s.site_contents
	s'.user_contents' = s.user_contents
	s'.memberships_user' = s.memberships_user - ((s.memberships_user).x <: s.memberships_user)
	s'.articles_user' = s.articles_user
	s'.assigned_assets_asset' = s.assigned_assets_asset
	s'.site_assets' = s.site_assets
	s'.assigned_sections_section' = s.assigned_sections_section
	s'.article_assigned_sections' = s.article_assigned_sections
	s'.assigned_assets_article' = s.assigned_assets_article
	s'.unapproved_comments_article' = s.unapproved_comments_article
	s'.comments_article' = s.comments_article
	s'.events_article' = s.events_article
	s'.updater_articles' = s.updater_articles
	s'.event_comment' = s.event_comment
	s'.article_comments' = s.article_comments
	s'.user_events' = s.user_events

}

pred deleteContent [s: PreState, s': PostState, x:Content] { 
	s'.memberships' = s.memberships
	s'.events' = s.events
	s'.taggings' = s.taggings
	s'.comments' = s.comments
	s'.assignedassets' = s.assignedassets
	s'.articles' = s.articles
	s'.assignedsections' = s.assignedsections
	s'.sections' = s.sections
	s'.assets' = s.assets
	s'.users' = s.users
	s'.contents' = s.contents - x
	s'.sites' = s.sites
	s'.tags' = s.tags
	s'.cachedpages' = s.cachedpages

	s'.site_cachedpage' = s.site_cachedpage
	s'.taggings_tag' = s.taggings_tag
	s'.unapproved_comments_site' = s.unapproved_comments_site
	s'.comments_site' = s.comments_site
	s'.memberships_site' = s.memberships_site
	s'.assets_site' = s.assets_site
	s'.events_site' = s.events_site
	s'.sections_site' = s.sections_site
	s'.site_contents' = s.site_contents - (s.site_contents :> x)
	s'.user_contents' = s.user_contents - (s.user_contents :> x)
	s'.memberships_user' = s.memberships_user
	s'.articles_user' = s.articles_user
	s'.assigned_assets_asset' = s.assigned_assets_asset
	s'.site_assets' = s.site_assets
	s'.assigned_sections_section' = s.assigned_sections_section
	s'.article_assigned_sections' = s.article_assigned_sections
	s'.assigned_assets_article' = s.assigned_assets_article
	s'.unapproved_comments_article' = s.unapproved_comments_article
	s'.comments_article' = s.comments_article
	s'.events_article' = s.events_article
	s'.updater_articles' = s.updater_articles
	s'.event_comment' = s.event_comment
	s'.article_comments' = s.article_comments
	s'.user_events' = s.user_events

}

pred deleteSite [s: PreState, s': PostState, x:Site] { 
	s'.memberships' = s.memberships - (s.memberships_site).x
	s'.events' = s.events - (s.events_site).x
	s'.taggings' = s.taggings
	s'.comments' = s.comments - (s.comments_site).x
	s'.assignedassets' = s.assignedassets
	s'.articles' = s.articles
	s'.assignedsections' = s.assignedsections - (s.assigned_sections_section).((s.sections_site).x)
	s'.sections' = s.sections - (s.sections_site).x
	s'.assets' = s.assets - x.(s.site_assets)
	s'.users' = s.users
	s'.contents' = s.contents
	s'.sites' = s.sites - x
	s'.tags' = s.tags
	s'.cachedpages' = s.cachedpages

	s'.site_cachedpage' = s.site_cachedpage
	s'.taggings_tag' = s.taggings_tag
	s'.unapproved_comments_site' = s.unapproved_comments_site
	s'.comments_site' = s.comments_site
	s'.memberships_site' = s.memberships_site - ((s.memberships_site).x <: s.memberships_site)
	s'.assets_site' = s.assets_site
	s'.events_site' = s.events_site - ((s.events_site).x <: s.events_site)
	s'.sections_site' = s.sections_site - ((s.sections_site).x <: s.sections_site)
	s'.site_contents' = s.site_contents
	s'.user_contents' = s.user_contents
	s'.memberships_user' = s.memberships_user - ((s.memberships_site).x <: s.memberships_user)
	s'.articles_user' = s.articles_user
	s'.assigned_assets_asset' = s.assigned_assets_asset
	s'.site_assets' = s.site_assets - (s.site_assets :> x.(s.site_assets))
	s'.assigned_sections_section' = s.assigned_sections_section - ((s.assigned_sections_section).((s.sections_site).x) <: s.assigned_sections_section)
	s'.article_assigned_sections' = s.article_assigned_sections - (s.article_assigned_sections :> (s.assigned_sections_section).((s.sections_site).x))
	s'.assigned_assets_article' = s.assigned_assets_article
	s'.unapproved_comments_article' = s.unapproved_comments_article
	s'.comments_article' = s.comments_article
	s'.events_article' = s.events_article - ((s.events_site).x <: s.events_article)
	s'.updater_articles' = s.updater_articles
	s'.event_comment' = s.event_comment - ((s.events_site).x <: s.event_comment)
	s'.article_comments' = s.article_comments - (s.article_comments :> (s.comments_site).x)
	s'.user_events' = s.user_events - (s.user_events :> (s.events_site).x)

}

pred deleteTag [s: PreState, s': PostState, x:Tag] { 
	s'.memberships' = s.memberships
	s'.events' = s.events
	s'.taggings' = s.taggings
	s'.comments' = s.comments
	s'.assignedassets' = s.assignedassets
	s'.articles' = s.articles
	s'.assignedsections' = s.assignedsections
	s'.sections' = s.sections
	s'.assets' = s.assets
	s'.users' = s.users
	s'.contents' = s.contents
	s'.sites' = s.sites
	s'.tags' = s.tags - x
	s'.cachedpages' = s.cachedpages

	s'.site_cachedpage' = s.site_cachedpage
	s'.taggings_tag' = s.taggings_tag
	s'.unapproved_comments_site' = s.unapproved_comments_site
	s'.comments_site' = s.comments_site
	s'.memberships_site' = s.memberships_site
	s'.assets_site' = s.assets_site
	s'.events_site' = s.events_site
	s'.sections_site' = s.sections_site
	s'.site_contents' = s.site_contents
	s'.user_contents' = s.user_contents
	s'.memberships_user' = s.memberships_user
	s'.articles_user' = s.articles_user
	s'.assigned_assets_asset' = s.assigned_assets_asset
	s'.site_assets' = s.site_assets
	s'.assigned_sections_section' = s.assigned_sections_section
	s'.article_assigned_sections' = s.article_assigned_sections
	s'.assigned_assets_article' = s.assigned_assets_article
	s'.unapproved_comments_article' = s.unapproved_comments_article
	s'.comments_article' = s.comments_article
	s'.events_article' = s.events_article
	s'.updater_articles' = s.updater_articles
	s'.event_comment' = s.event_comment
	s'.article_comments' = s.article_comments
	s'.user_events' = s.user_events

}

pred deleteCachedPage [s: PreState, s': PostState, x:CachedPage] { 
	s'.memberships' = s.memberships
	s'.events' = s.events
	s'.taggings' = s.taggings
	s'.comments' = s.comments
	s'.assignedassets' = s.assignedassets
	s'.articles' = s.articles
	s'.assignedsections' = s.assignedsections
	s'.sections' = s.sections
	s'.assets' = s.assets
	s'.users' = s.users
	s'.contents' = s.contents
	s'.sites' = s.sites
	s'.tags' = s.tags
	s'.cachedpages' = s.cachedpages - x

	s'.site_cachedpage' = s.site_cachedpage - (s.site_cachedpage :> x)
	s'.taggings_tag' = s.taggings_tag
	s'.unapproved_comments_site' = s.unapproved_comments_site
	s'.comments_site' = s.comments_site
	s'.memberships_site' = s.memberships_site
	s'.assets_site' = s.assets_site
	s'.events_site' = s.events_site
	s'.sections_site' = s.sections_site
	s'.site_contents' = s.site_contents
	s'.user_contents' = s.user_contents
	s'.memberships_user' = s.memberships_user
	s'.articles_user' = s.articles_user
	s'.assigned_assets_asset' = s.assigned_assets_asset
	s'.site_assets' = s.site_assets
	s'.assigned_sections_section' = s.assigned_sections_section
	s'.article_assigned_sections' = s.article_assigned_sections
	s'.assigned_assets_article' = s.assigned_assets_article
	s'.unapproved_comments_article' = s.unapproved_comments_article
	s'.comments_article' = s.comments_article
	s'.events_article' = s.events_article
	s'.updater_articles' = s.updater_articles
	s'.event_comment' = s.event_comment
	s'.article_comments' = s.article_comments
	s'.user_events' = s.user_events

}
