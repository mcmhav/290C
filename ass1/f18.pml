/* f18 */

#define state1 state==agreementS
#define state2 state==notAgreeS
#define state3 state==agreeS

#define state4 state==menuPageS
#define state5 state==animationS
#define state6 state==hlAS
#define state7 state==hlBS
#define state8 state==hlCS

#define state9 state==AS
#define state10 state==BS
#define state11 state==CS

#define p (state==AS)
#define q (state==CS)

/* Used for events and used to check for states with p */
mtype = {check, uncheck, menu, dispA, dispB, dispC, moA, moB, moC, mc, 
		agreementS, notAgreeS, agreeS, menuPageS, animationS, hlAS, hlBS,
		hlCS, AS, BS, CS} 

mtype state;

/* 
	The agreement state with its 3 states and their possible actions
*/
proctype agreem()
{
agreement:
	state = agreementS;
	goto notAgree;

notAgree: 
	state = notAgreeS;
	if
	:: check -> goto agree
	fi;

agree: 
	state = agreeS;
	if
	:: uncheck -> goto notAgree
	:: menu -> run men()
	fi
}

/*
	The menu state
	This initializes the two states JAVA and display to run atomic
*/
proctype men()
{
menuPage: 
	state = menuPageS;
	atomic {
		run JAVA();
		run display()
	};
}


/*
	The java state, initialized with the animations, and enters from there
	the highlightA state, moves between the different states based on the 
	different events.
*/
proctype JAVA()
{
animation:
	state = animationS;
	goto hlA;

hlA:
	state = hlAS;
	if
	:: (dispA || mc) -> goto hlA 
	:: moB -> goto hlB
	:: moC -> goto hlC
	fi;

hlB:
	state = hlBS;
	if
	:: (mc || dispB) -> goto hlB
	:: moC -> goto hlC
	:: moA -> goto hlA
	fi;

hlC:
	state = hlCS;
	if
	:: (mc || dispC) -> goto hlC
	:: moB -> goto hlB
	:: moA -> goto hlA
	fi
}

/*
	The display states. Starts with the A state, and shifts based on 
	the events triggered. This depends on that A is always triggered first 
	though. But based on the "Test examples" from spin's web page, the
	first state in a proctype is run first.
*/
proctype display()
{
A:
	state = AS;
	if
	:: dispB -> goto B
	:: dispC -> goto C
	fi;

B:
	state = BS;
	if
	:: dispC -> goto C
	:: dispA -> goto A
	fi;

C:
	state = CS;
	if
	:: dispB -> goto B
	:: dispA -> goto A
	fi;
}

init 
{
	/*
		Initialize the system from agreement state, where it all starts
	*/
	run agreem();
}
