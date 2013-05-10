abstract sig ActiveRecord { } 
sig List extends ActiveRecord { }
sig Setting extends ActiveRecord { }

one sig PreState { 
	lists: set List, 
	settings: set Setting, 


}{
	all x: List | x in lists
	all x: Setting | x in settings
}

one sig PostState { 
	lists': set List, 
	settings': set Setting, 


}


pred deleteList [s: PreState, s': PostState, x:List] { 
	s'.lists' = s.lists - x
	s'.settings' = s.settings


}

pred deleteSetting [s: PreState, s': PostState, x:Setting] { 
	s'.lists' = s.lists
	s'.settings' = s.settings - x


}
