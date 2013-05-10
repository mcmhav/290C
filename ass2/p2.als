/**

2. Extend the above DLL speciﬁcation in Alloy by writing the predicates for the add and delete operations. Assume that the add operation adds the new node to the head of the DLL (i.e., the new node becomes the new head) and the delete operation removes the tail node (i.e., the prev of the tail becomes the new tail). 
Hint: Specify prev and next as relations (using the cross product ->). 
Specify and check or simulate the following properties for scopes 2 and 3 using the Alloy Analyzer: 
    1) It is possible to obtain an empty DLL after a delete. 
    2) After an add the DLL contains at least one node. 
    3) Adding a node to a DLL increases the size of its contents by one. 
    4) Deleting a node from a DLL decreases the size of its contents by one. 
    5) After an add, the next of the new head is the old head. 
    6) After a delete, the new tail is the prev of the old tail.

**/