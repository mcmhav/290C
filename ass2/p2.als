/**

2. Extend the above DLL speciﬁcation in Alloy by writing the predicates for the add and delete operations. 
Assume that the add operation adds the new node to the head of the DLL 
	(i.e., the new node becomes the new head) 
and the delete operation removes the tail node 
	(i.e., the prev of the tail becomes the new tail). 

Hint: Specify prev and next as relations (using the cross product ->). 
Specify and check or simulate the following properties for scopes 2 and 3 using the Alloy Analyzer: 

D    1) It is possible to obtain an empty DLL after a delete. 
D    2) After an add the DLL contains at least one node. 
D    3) Adding a node to a DLL increases the size of its contents by one. 
D    4) Deleting a node from a DLL decreases the size of its contents by one. 
D    5) After an add, the next of the new head is the old head. 
D    6) After a delete, the new tail is the prev of the old tail.

Made two versions, the most readable will in a sense not follow the specifications
as the next and previous arrows is shown from deleted and added for both pre
and post state, but the other version is closeto unreadable, so I think the first 
version is the best.

**/

sig Node {
    next : lone Node,
	prev: lone Node
}

one sig PreDLLState { 
	nodes: set Node, 
	Head: lone Node,
	Tail: lone Node
}{
	all n : Node | n not in n.^next
	all n : Node | n not in n.^prev
    no prev.Tail
	all n : Node, o: n.next | o.prev = n
}

one sig PostDLLState { 
	nodes': set Node, 
	Head': lone Node,
	Tail': lone Node
}{}

pred add [s: PreDLLState, s': PostDLLState, n:Node] { 
	all x: Node | x in s'.nodes'
	all n : Node - s'.Head' | some next.n
	all n : Node - s'.Tail' | some prev.n
	n = s'.Head'
	s.Head = s'.Head'.next
	s.Tail = s'.Tail' - s'.Head'
	s.nodes = s'.nodes' - n
	
}
pred delete [s: PreDLLState, s': PostDLLState, n:Node] { 
	all x: Node | x in s.nodes
	all n : Node - s.Head | some next.n
	all n : Node - s.Tail | some prev.n
	n = s.Tail
	s'.Tail' = s.Tail.prev
	s'.Head' = s.Head - s.Tail
	s'.nodes' = s.nodes - n
}

run add for 3 Node
//run delete for 4 Node



/**
sig Node{}

one sig PreDLLState {
    nodes: set Node,
    next: nodes lone->lone nodes,
    prev: nodes lone->lone nodes,
    Head: lone Node,
    Tail: lone Node
}{
    all x:nodes | x not in x.^next
    all x:nodes | x not in x.^prev
    no Head.prev
    no Tail.next

	all h:Head | h in nodes
	all t:Tail | t in nodes

    Head.^next=nodes-Head
    Tail.^prev=nodes-Tail
    all x,x1:nodes | (x.next=x1) =>(x1.prev=x)
}

one sig PostDLLState {
    nodes': set Node,
    next': nodes' lone->lone nodes',
    prev': nodes' lone->lone nodes',
    Head': lone Node,
    Tail': lone Node
}

pred add [s: PreDLLState, s': PostDLLState, n:Node] { 
	n = s'.Head'
	s.Head = s'.Head'.(s'.next')
	s.Tail = s'.Tail' - s'.Head'
	s.nodes = s'.nodes' - n
}
pred delete [s: PreDLLState, s': PostDLLState, n:Node] { 
	n = s.Tail
	s'.Tail' = (s.Tail.(s.prev))
	s'.Head' = s.Head - s.Tail
	s'.nodes' = s.nodes - n
}

run add for 3 Node
//run delete for 3 Node  **/
