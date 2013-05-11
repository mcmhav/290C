/**

1. Consider a Doubly Linked List (DLL). If a DLL is not empty, its head is a node that does not have a prev node. If a DLL is not empty, its tail is a node that does not have a next node. An empty DLL does not have a head node. The contents of a DLL is the set of nodes that are reachable from the head node by following the next links, plus the head node. The tail node is included in the contents. For all nodes that are reachable from the head node, the next of the prev of the node is itself. 
Write the above DLL speciﬁcation in Alloy. 
Specify and check or simulate the following properties for scopes 2 and 3 using the Alloy Analyzer: 
    
D  1) There exist DLLs with 0, 1, 2, and 3 nodes. 
D  2) A DLL does not have a tail node if and only if it is empty. 
D  3) For all DLLs, if head and tail are the same node, then the size of the DLL is 1. 
D  4) No node in a DLL is the prev of two diﬀerent nodes or the next of two diﬀerent nodes. 
D  5) There are no cycles (i.e., a node is not reachable from itself by just following next links or by just following prev links).

**/

sig Node {
    next : lone Node,
	prev: lone Node
} 

one sig DDL {
	Head: lone Node,
	Tail: lone Node
}{
    all n : Node | n not in n.^next
    no next.Head
    all n : Node - Head | some next.n

	all n : Node | n not in n.^prev
    no prev.Tail
    all n : Node - Tail | some prev.n
	
	all n : Node, o: n.next | o.prev = n
}

run {} for 4
