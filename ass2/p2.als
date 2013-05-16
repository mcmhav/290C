/**

2. Extend the above DLL speciﬁcation in Alloy by writing the predicates for the add and delete operations. Assume that the add operation adds the new node to the head of the DLL (i.e., the new node becomes the new head) and the delete operation removes the tail node (i.e., the prev of the tail becomes the new tail). 
Hint: Specify prev and next as relations (using the cross product ->). 
Specify and check or simulate the following properties for scopes 2 and 3 using the Alloy Analyzer: 

D    1) It is possible to obtain an empty DLL after a delete. 
D   2) After an add the DLL contains at least one node. 
D    3) Adding a node to a DLL increases the size of its contents by one. 
D    4) Deleting a node from a DLL decreases the size of its contents by one. 
D    5) After an add, the next of the new head is the old head. 
    6) After a delete, the new tail is the prev of the old tail.



sig Node {
    next : lone Node,
	prev: lone Node
} 

some sig DDL {
	live: set Node,
	Head: lone Node,
	Tail: lone Node,
	nodes: live -> Head
}{
    all n : Node | n not in n.^next
    no next.Head
    all n : Node - Head | some next.n

	all n : Node | n not in n.^prev
    no prev.Tail
    all n : Node - Tail | some prev.n
	
	all n : Node, o: n.next | o.prev = n

	live = Head.*next
	//live in Head.*next + Head
}

pred add [n: Node, d: DDL]{
	n = d.Head
}

pred remove [d, d': DDL]{
	//d'.nodes = d.nodes - d.Tail -> (d.Tail.(d.nodes))
	//d'.Tail = d.Tail.prev
	d'.nodes = d.nodes - d.Tail -> ((d.Tail).(d.nodes))
}

run remove for 2 exactly DDL, 4 Node

**/

sig node{
	//next: lone node -> lone node,
	//prev: lone node -> lone node
}
some sig DLL
{
    live: set node,
    next: live lone->lone live,
    prev: live lone->lone live,
    head: lone node,
    tail: lone node
} 
{
    all x:live | x not in x.^next
    all x:live | x not in x.^prev
    no head.prev
    no tail.next

	all h:head | h in live
	all t:tail | t in live

    head.^next=live-head
    tail.^prev=live-tail
    all x,x1:live | (x.next=x1) =>(x1.prev=x)
}

pred add [n: node, d: DLL]{
	n = d.head
}

pred remove [d,d': DLL, n: node] {
	//n = d.tail
	//d'.tail = d.prev
	d'.live = d.live - n
}

run remove for exactly 1 DLL, 4 node         
