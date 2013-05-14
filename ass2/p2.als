/**

2. Extend the above DLL speciﬁcation in Alloy by writing the predicates for the add and delete operations. Assume that the add operation adds the new node to the head of the DLL (i.e., the new node becomes the new head) and the delete operation removes the tail node (i.e., the prev of the tail becomes the new tail). 
Hint: Specify prev and next as relations (using the cross product ->). 
Specify and check or simulate the following properties for scopes 2 and 3 using the Alloy Analyzer: 

    1) It is possible to obtain an empty DLL after a delete. 
D   2) After an add the DLL contains at least one node. 
    3) Adding a node to a DLL increases the size of its contents by one. 
    4) Deleting a node from a DLL decreases the size of its contents by one. 
    5) After an add, the next of the new head is the old head. 
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
**

// File system objects
abstract sig FSObject { }
sig File, Dir extends FSObject { }

// A File System
sig FileSystem {
  live: set FSObject,
  root: Dir & live,
  parent: (live - root) ->one (Dir & live),
  contents: Dir -> FSObject
}{
  // live objects are reachable from the root
  live in root.*contents
  // parent is the inverse of contents
  parent = ~contents
}

// Delete the file or directory x
pred remove [fs, fs': FileSystem, x: FSObject] {
  x in (fs.live - fs.root)
  fs'.parent = fs.parent - x->(x.(fs.parent))
}

run remove for exactly 2 FileSystem, 4 FSObject
**/

sig node{}
sig DLL
{
    live: set node,
    next: live lone->lone live,
    prev: live lone->lone live,
    head: one node,
    tail: one node
} 
{
    all x:live | x not in x.^next
    all x:live | x not in x.^prev
    no head.prev
    no tail.next

    head.^next=live-head
    tail.^prev=live-tail
    all x,x1:live | (x.next=x1) =>(x1.prev=x)
}

pred remove [d,d': DLL, n: node] {
	n = d.tail
	d'.tail = d.tail.prev
	d'.prev = d.prev - n->(n.(d.prev))
}

run {} for exactly 2 list, 4 node         
