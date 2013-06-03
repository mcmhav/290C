/*
(a) For each of the above two choreography descriptions, write three Promela speciﬁcations: 
    - Write a Promela speciﬁcation that corresponds to the conversation protocol of each choreography 
    - Write a Promela speciﬁcation that contains one process for each peer and uses communication channels for the communication among the peers (where each peer has a separate receive queue). Bound the size of the communication channels to 10. 
    - Write another speciﬁcation like (2) but set the channel sizes to zero to represent synchronous communication
*/

mtype = {requestLarge, requestSmall, check, riskLow, riskHigh, approved, denied,
        customerS, loanApproverS, riskAssessorS} 

mtype state;

proctype loan()
{
customer:
    state = animationS;
    goto hlA;

loanApprover:
    state = hlAS;
    if
    :: (dispA || mc) -> goto hlA 
    :: moB -> goto hlB
    :: moC -> goto hlC
    fi;

riskAsserssor:
    

}


/*
(b) For speciﬁcations (2) and (3) use Spin to check if they contain deadlocks. 
*/

/*
(c) For the Loan Approval service check the following LTL properties on all three Promela speciﬁcations: 
    - G(request-small ⇒ F approved)
    - F(approved ∨ denied)
    - G(request-large ⇒ F(risk-low ∨ risk-high)). Discuss the results
*/

/*
(d) For the Ticket Purchase choreography check the following LTL properties on all three Promela speciﬁcations: 
    - G(buy ⇒ F conﬁrm)
    - F(conﬁrm ∨ cancel ∨ timeout)
    - G(timeout ⇒ ¬ F(cancel ∨ conﬁrm)). Discuss the results.
*/

