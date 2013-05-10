abstract sig ActiveRecord { } 
sig Context extends ActiveRecord { }
sig Dependency extends ActiveRecord { }
sig Todo extends ActiveRecord { }
sig Tagging extends ActiveRecord { }
sig Note extends ActiveRecord { }
sig RecurringTodo extends ActiveRecord { }
sig Preference extends ActiveRecord { }
sig User extends ActiveRecord { }
sig Todo_2 in Todo { } 
sig Tag extends ActiveRecord { }
sig Project extends ActiveRecord { }
sig Taggable in ActiveRecord { }

one sig PreState { 
	contexts: set Context, 
	dependencies: set Dependency, 
	todos: set Todo, 
	uncompletedpredecessor_0s: set UncompletedPredecessor_0, 
	pendingsuccessor_1s: set PendingSuccessor_1, 
	taggings: set Tagging, 
	notes: set Note, 
	recurringtodos: set RecurringTodo, 
	preferences: set Preference, 
	users: set User, 
	todo_2s: set Todo_2, 
	tags: set Tag, 
	projects: set Project, 
	taggables: set Taggable, 

	user_projects: User one -> set Project,
	default_context_projects: Context one -> set Project,
	recurring_todos_project: RecurringTodo set -> one Project,
	notes_project: Note set -> one Project,
	todos_project: Todo set -> one Project,
	taggings_tag: Tagging set -> one Tag,
	preference_user: Preference lone -> one User,
	notes_user: Note set -> one User,
	deferred_todos_user: Todo_2 set -> set User,
	recurring_todos_user: RecurringTodo set -> one User,
	todos_user: Todo set -> one User,
	contexts_user: Context set -> one User,
	sms_context_preferences: Context one -> set Preference,
	todos_recurring_todo: Todo set -> one RecurringTodo,
	context_recurring_todos: Context one -> set RecurringTodo,
	successor_dependencies_predecessor: Dependency set -> one Todo,
	predecessor_dependencies_successor: Dependency set -> one Todo,
	context_todos: Context one -> set Todo,

}{
	all x: Context | x in contexts
	all x: Dependency | x in dependencies
	all x: Todo | x in todos
	all x: UncompletedPredecessor_0 | x in uncompletedpredecessor_0s
	all x: PendingSuccessor_1 | x in pendingsuccessor_1s
	all x: Tagging | x in taggings
	all x: Note | x in notes
	all x: RecurringTodo | x in recurringtodos
	all x: Preference | x in preferences
	all x: User | x in users
	all x: Todo_2 | x in todo_2s
	all x: Tag | x in tags
	all x: Project | x in projects
	all x: Taggable | x in taggables
}

one sig PostState { 
	contexts': set Context, 
	dependencies': set Dependency, 
	todos': set Todo, 
	uncompletedpredecessor_0s': set UncompletedPredecessor_0, 
	pendingsuccessor_1s': set PendingSuccessor_1, 
	taggings': set Tagging, 
	notes': set Note, 
	recurringtodos': set RecurringTodo, 
	preferences': set Preference, 
	users': set User, 
	todo_2s': set Todo_2, 
	tags': set Tag, 
	projects': set Project, 
	taggables': set Taggable, 

	user_projects': User set -> set Project,
	default_context_projects': Context set -> set Project,
	recurring_todos_project': RecurringTodo set -> set Project,
	notes_project': Note set -> set Project,
	todos_project': Todo set -> set Project,
	taggings_tag': Tagging set -> set Tag,
	preference_user': Preference set -> set User,
	notes_user': Note set -> set User,
	deferred_todos_user': Todo_2 set -> set User,
	recurring_todos_user': RecurringTodo set -> set User,
	todos_user': Todo set -> set User,
	contexts_user': Context set -> set User,
	sms_context_preferences': Context set -> set Preference,
	todos_recurring_todo': Todo set -> set RecurringTodo,
	context_recurring_todos': Context set -> set RecurringTodo,
	successor_dependencies_predecessor': Dependency set -> set Todo,
	predecessor_dependencies_successor': Dependency set -> set Todo,
	context_todos': Context set -> set Todo,

}


pred deleteContext [s: PreState, s': PostState, x:Context] { 
	s'.contexts' = s.contexts - x
	s'.dependencies' = s.dependencies
	s'.todos' = s.todos - x.(s.context_recurring_todos)
	s'.taggings' = s.taggings
	s'.notes' = s.notes
	s'.recurringtodos' = s.recurringtodos - x.(s.context_recurring_todos)
	s'.preferences' = s.preferences
	s'.users' = s.users
	s'.tags' = s.tags
	s'.projects' = s.projects

	s'.user_projects' = s.user_projects
	s'.default_context_projects' = s.default_context_projects
	s'.recurring_todos_project' = s.recurring_todos_project - (x.(s.context_recurring_todos) <: s.recurring_todos_project)
	s'.notes_project' = s.notes_project
	s'.todos_project' = s.todos_project - (x.(s.context_recurring_todos) <: s.todos_project)
	s'.taggings_tag' = s.taggings_tag
	s'.preference_user' = s.preference_user
	s'.notes_user' = s.notes_user
	s'.deferred_todos_user' = s.deferred_todos_user
	s'.recurring_todos_user' = s.recurring_todos_user - (x.(s.context_recurring_todos) <: s.recurring_todos_user)
	s'.todos_user' = s.todos_user - (x.(s.context_recurring_todos) <: s.todos_user)
	s'.contexts_user' = s.contexts_user - (x <: s.contexts_user)
	s'.sms_context_preferences' = s.sms_context_preferences
	s'.todos_recurring_todo' = s.todos_recurring_todo - (x.(s.context_recurring_todos) <: s.todos_recurring_todo)
	s'.context_recurring_todos' = s.context_recurring_todos - (s.context_recurring_todos :> x.(s.context_recurring_todos))
	s'.successor_dependencies_predecessor' = s.successor_dependencies_predecessor
	s'.predecessor_dependencies_successor' = s.predecessor_dependencies_successor
	s'.context_todos' = s.context_todos - (s.context_todos :> x.(s.context_recurring_todos))

}

pred deleteDependency [s: PreState, s': PostState, x:Dependency] { 
	s'.contexts' = s.contexts
	s'.dependencies' = s.dependencies - x
	s'.todos' = s.todos
	s'.taggings' = s.taggings
	s'.notes' = s.notes
	s'.recurringtodos' = s.recurringtodos
	s'.preferences' = s.preferences
	s'.users' = s.users
	s'.tags' = s.tags
	s'.projects' = s.projects

	s'.user_projects' = s.user_projects
	s'.default_context_projects' = s.default_context_projects
	s'.recurring_todos_project' = s.recurring_todos_project
	s'.notes_project' = s.notes_project
	s'.todos_project' = s.todos_project
	s'.taggings_tag' = s.taggings_tag
	s'.preference_user' = s.preference_user
	s'.notes_user' = s.notes_user
	s'.deferred_todos_user' = s.deferred_todos_user
	s'.recurring_todos_user' = s.recurring_todos_user
	s'.todos_user' = s.todos_user
	s'.contexts_user' = s.contexts_user
	s'.sms_context_preferences' = s.sms_context_preferences
	s'.todos_recurring_todo' = s.todos_recurring_todo
	s'.context_recurring_todos' = s.context_recurring_todos
	s'.successor_dependencies_predecessor' = s.successor_dependencies_predecessor - (x <: s.successor_dependencies_predecessor)
	s'.predecessor_dependencies_successor' = s.predecessor_dependencies_successor - (x <: s.predecessor_dependencies_successor)
	s'.context_todos' = s.context_todos

}

pred deleteTodo [s: PreState, s': PostState, x:Todo] { 
	s'.contexts' = s.contexts
	s'.dependencies' = s.dependencies - (s.predecessor_dependencies_successor).x - (s.successor_dependencies_predecessor).x
	s'.todos' = s.todos - x
	s'.taggings' = s.taggings
	s'.notes' = s.notes
	s'.recurringtodos' = s.recurringtodos
	s'.preferences' = s.preferences
	s'.users' = s.users
	s'.tags' = s.tags
	s'.projects' = s.projects

	s'.user_projects' = s.user_projects
	s'.default_context_projects' = s.default_context_projects
	s'.recurring_todos_project' = s.recurring_todos_project
	s'.notes_project' = s.notes_project
	s'.todos_project' = s.todos_project - (x <: s.todos_project)
	s'.taggings_tag' = s.taggings_tag
	s'.preference_user' = s.preference_user
	s'.notes_user' = s.notes_user
	s'.deferred_todos_user' = s.deferred_todos_user
	s'.recurring_todos_user' = s.recurring_todos_user
	s'.todos_user' = s.todos_user - (x <: s.todos_user)
	s'.contexts_user' = s.contexts_user
	s'.sms_context_preferences' = s.sms_context_preferences
	s'.todos_recurring_todo' = s.todos_recurring_todo - (x <: s.todos_recurring_todo)
	s'.context_recurring_todos' = s.context_recurring_todos
	s'.successor_dependencies_predecessor' = s.successor_dependencies_predecessor - ((s.predecessor_dependencies_successor).x <: s.successor_dependencies_predecessor) - ((s.successor_dependencies_predecessor).x <: s.successor_dependencies_predecessor)
	s'.predecessor_dependencies_successor' = s.predecessor_dependencies_successor - ((s.predecessor_dependencies_successor).x <: s.predecessor_dependencies_successor) - ((s.successor_dependencies_predecessor).x <: s.predecessor_dependencies_successor)
	s'.context_todos' = s.context_todos - (s.context_todos :> x)

}

pred deleteTagging [s: PreState, s': PostState, x:Tagging] { 
	s'.contexts' = s.contexts
	s'.dependencies' = s.dependencies
	s'.todos' = s.todos
	s'.taggings' = s.taggings - x
	s'.notes' = s.notes
	s'.recurringtodos' = s.recurringtodos
	s'.preferences' = s.preferences
	s'.users' = s.users
	s'.tags' = s.tags
	s'.projects' = s.projects

	s'.user_projects' = s.user_projects
	s'.default_context_projects' = s.default_context_projects
	s'.recurring_todos_project' = s.recurring_todos_project
	s'.notes_project' = s.notes_project
	s'.todos_project' = s.todos_project
	s'.taggings_tag' = s.taggings_tag - (x <: s.taggings_tag)
	s'.preference_user' = s.preference_user
	s'.notes_user' = s.notes_user
	s'.deferred_todos_user' = s.deferred_todos_user
	s'.recurring_todos_user' = s.recurring_todos_user
	s'.todos_user' = s.todos_user
	s'.contexts_user' = s.contexts_user
	s'.sms_context_preferences' = s.sms_context_preferences
	s'.todos_recurring_todo' = s.todos_recurring_todo
	s'.context_recurring_todos' = s.context_recurring_todos
	s'.successor_dependencies_predecessor' = s.successor_dependencies_predecessor
	s'.predecessor_dependencies_successor' = s.predecessor_dependencies_successor
	s'.context_todos' = s.context_todos

}

pred deleteNote [s: PreState, s': PostState, x:Note] { 
	s'.contexts' = s.contexts
	s'.dependencies' = s.dependencies
	s'.todos' = s.todos
	s'.taggings' = s.taggings
	s'.notes' = s.notes - x
	s'.recurringtodos' = s.recurringtodos
	s'.preferences' = s.preferences
	s'.users' = s.users
	s'.tags' = s.tags
	s'.projects' = s.projects

	s'.user_projects' = s.user_projects
	s'.default_context_projects' = s.default_context_projects
	s'.recurring_todos_project' = s.recurring_todos_project
	s'.notes_project' = s.notes_project - (x <: s.notes_project)
	s'.todos_project' = s.todos_project
	s'.taggings_tag' = s.taggings_tag
	s'.preference_user' = s.preference_user
	s'.notes_user' = s.notes_user - (x <: s.notes_user)
	s'.deferred_todos_user' = s.deferred_todos_user
	s'.recurring_todos_user' = s.recurring_todos_user
	s'.todos_user' = s.todos_user
	s'.contexts_user' = s.contexts_user
	s'.sms_context_preferences' = s.sms_context_preferences
	s'.todos_recurring_todo' = s.todos_recurring_todo
	s'.context_recurring_todos' = s.context_recurring_todos
	s'.successor_dependencies_predecessor' = s.successor_dependencies_predecessor
	s'.predecessor_dependencies_successor' = s.predecessor_dependencies_successor
	s'.context_todos' = s.context_todos

}

pred deleteRecurringTodo [s: PreState, s': PostState, x:RecurringTodo] { 
	s'.contexts' = s.contexts
	s'.dependencies' = s.dependencies
	s'.todos' = s.todos
	s'.taggings' = s.taggings
	s'.notes' = s.notes
	s'.recurringtodos' = s.recurringtodos - x
	s'.preferences' = s.preferences
	s'.users' = s.users
	s'.tags' = s.tags
	s'.projects' = s.projects

	s'.user_projects' = s.user_projects
	s'.default_context_projects' = s.default_context_projects
	s'.recurring_todos_project' = s.recurring_todos_project - (x <: s.recurring_todos_project)
	s'.notes_project' = s.notes_project
	s'.todos_project' = s.todos_project
	s'.taggings_tag' = s.taggings_tag
	s'.preference_user' = s.preference_user
	s'.notes_user' = s.notes_user
	s'.deferred_todos_user' = s.deferred_todos_user
	s'.recurring_todos_user' = s.recurring_todos_user - (x <: s.recurring_todos_user)
	s'.todos_user' = s.todos_user
	s'.contexts_user' = s.contexts_user
	s'.sms_context_preferences' = s.sms_context_preferences
	s'.todos_recurring_todo' = s.todos_recurring_todo
	s'.context_recurring_todos' = s.context_recurring_todos - (s.context_recurring_todos :> x)
	s'.successor_dependencies_predecessor' = s.successor_dependencies_predecessor
	s'.predecessor_dependencies_successor' = s.predecessor_dependencies_successor
	s'.context_todos' = s.context_todos

}

pred deletePreference [s: PreState, s': PostState, x:Preference] { 
	s'.contexts' = s.contexts
	s'.dependencies' = s.dependencies
	s'.todos' = s.todos
	s'.taggings' = s.taggings
	s'.notes' = s.notes
	s'.recurringtodos' = s.recurringtodos
	s'.preferences' = s.preferences - x
	s'.users' = s.users
	s'.tags' = s.tags
	s'.projects' = s.projects

	s'.user_projects' = s.user_projects
	s'.default_context_projects' = s.default_context_projects
	s'.recurring_todos_project' = s.recurring_todos_project
	s'.notes_project' = s.notes_project
	s'.todos_project' = s.todos_project
	s'.taggings_tag' = s.taggings_tag
	s'.preference_user' = s.preference_user - (x <: s.preference_user)
	s'.notes_user' = s.notes_user
	s'.deferred_todos_user' = s.deferred_todos_user
	s'.recurring_todos_user' = s.recurring_todos_user
	s'.todos_user' = s.todos_user
	s'.contexts_user' = s.contexts_user
	s'.sms_context_preferences' = s.sms_context_preferences - (s.sms_context_preferences :> x)
	s'.todos_recurring_todo' = s.todos_recurring_todo
	s'.context_recurring_todos' = s.context_recurring_todos
	s'.successor_dependencies_predecessor' = s.successor_dependencies_predecessor
	s'.predecessor_dependencies_successor' = s.predecessor_dependencies_successor
	s'.context_todos' = s.context_todos

}

pred deleteUser [s: PreState, s': PostState, x:User] { 
	s'.contexts' = s.contexts - (s.contexts_user).x
	s'.dependencies' = s.dependencies
	s'.todos' = s.todos - (s.todos_user).x
	s'.taggings' = s.taggings
	s'.notes' = s.notes - (s.notes_user).x
	s'.recurringtodos' = s.recurringtodos - (s.recurring_todos_user).x
	s'.preferences' = s.preferences - (s.preference_user).x
	s'.users' = s.users - x
	s'.tags' = s.tags
	s'.projects' = s.projects - x.(s.user_projects)

	s'.user_projects' = s.user_projects - (s.user_projects :> x.(s.user_projects))
	s'.default_context_projects' = s.default_context_projects - (s.default_context_projects :> x.(s.user_projects))
	s'.recurring_todos_project' = s.recurring_todos_project - ((s.recurring_todos_user).x <: s.recurring_todos_project)
	s'.notes_project' = s.notes_project - ((s.notes_user).x <: s.notes_project)
	s'.todos_project' = s.todos_project - ((s.todos_user).x <: s.todos_project)
	s'.taggings_tag' = s.taggings_tag
	s'.preference_user' = s.preference_user - ((s.preference_user).x <: s.preference_user)
	s'.notes_user' = s.notes_user - ((s.notes_user).x <: s.notes_user)
	s'.deferred_todos_user' = s.deferred_todos_user
	s'.recurring_todos_user' = s.recurring_todos_user - ((s.recurring_todos_user).x <: s.recurring_todos_user)
	s'.todos_user' = s.todos_user - ((s.todos_user).x <: s.todos_user)
	s'.contexts_user' = s.contexts_user - ((s.contexts_user).x <: s.contexts_user)
	s'.sms_context_preferences' = s.sms_context_preferences - (s.sms_context_preferences :> (s.preference_user).x)
	s'.todos_recurring_todo' = s.todos_recurring_todo - ((s.todos_user).x <: s.todos_recurring_todo)
	s'.context_recurring_todos' = s.context_recurring_todos - (s.context_recurring_todos :> (s.recurring_todos_user).x)
	s'.successor_dependencies_predecessor' = s.successor_dependencies_predecessor
	s'.predecessor_dependencies_successor' = s.predecessor_dependencies_successor
	s'.context_todos' = s.context_todos - (s.context_todos :> (s.todos_user).x)

}

pred deleteTag [s: PreState, s': PostState, x:Tag] { 
	s'.contexts' = s.contexts
	s'.dependencies' = s.dependencies
	s'.todos' = s.todos
	s'.taggings' = s.taggings
	s'.notes' = s.notes
	s'.recurringtodos' = s.recurringtodos
	s'.preferences' = s.preferences
	s'.users' = s.users
	s'.tags' = s.tags - x
	s'.projects' = s.projects

	s'.user_projects' = s.user_projects
	s'.default_context_projects' = s.default_context_projects
	s'.recurring_todos_project' = s.recurring_todos_project
	s'.notes_project' = s.notes_project
	s'.todos_project' = s.todos_project
	s'.taggings_tag' = s.taggings_tag
	s'.preference_user' = s.preference_user
	s'.notes_user' = s.notes_user
	s'.deferred_todos_user' = s.deferred_todos_user
	s'.recurring_todos_user' = s.recurring_todos_user
	s'.todos_user' = s.todos_user
	s'.contexts_user' = s.contexts_user
	s'.sms_context_preferences' = s.sms_context_preferences
	s'.todos_recurring_todo' = s.todos_recurring_todo
	s'.context_recurring_todos' = s.context_recurring_todos
	s'.successor_dependencies_predecessor' = s.successor_dependencies_predecessor
	s'.predecessor_dependencies_successor' = s.predecessor_dependencies_successor
	s'.context_todos' = s.context_todos

}

pred deleteProject [s: PreState, s': PostState, x:Project] { 
	s'.contexts' = s.contexts
	s'.dependencies' = s.dependencies
	s'.todos' = s.todos - (s.todos_project).x
	s'.taggings' = s.taggings
	s'.notes' = s.notes - (s.notes_project).x
	s'.recurringtodos' = s.recurringtodos
	s'.preferences' = s.preferences
	s'.users' = s.users
	s'.tags' = s.tags
	s'.projects' = s.projects - x

	s'.user_projects' = s.user_projects - (s.user_projects :> x)
	s'.default_context_projects' = s.default_context_projects - (s.default_context_projects :> x)
	s'.recurring_todos_project' = s.recurring_todos_project
	s'.notes_project' = s.notes_project - ((s.notes_project).x <: s.notes_project)
	s'.todos_project' = s.todos_project - ((s.todos_project).x <: s.todos_project)
	s'.taggings_tag' = s.taggings_tag
	s'.preference_user' = s.preference_user
	s'.notes_user' = s.notes_user - ((s.notes_project).x <: s.notes_user)
	s'.deferred_todos_user' = s.deferred_todos_user
	s'.recurring_todos_user' = s.recurring_todos_user
	s'.todos_user' = s.todos_user - ((s.todos_project).x <: s.todos_user)
	s'.contexts_user' = s.contexts_user
	s'.sms_context_preferences' = s.sms_context_preferences
	s'.todos_recurring_todo' = s.todos_recurring_todo - ((s.todos_project).x <: s.todos_recurring_todo)
	s'.context_recurring_todos' = s.context_recurring_todos
	s'.successor_dependencies_predecessor' = s.successor_dependencies_predecessor
	s'.predecessor_dependencies_successor' = s.predecessor_dependencies_successor
	s'.context_todos' = s.context_todos - (s.context_todos :> (s.todos_project).x)

}
