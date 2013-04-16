/* f18 */

#define state1 menuState==menu
#define stateJ4 javaState==animation
#define stateJ1 javaState==highlightA
#define stateJ2 javaState==highlightB
#define stateJ3 javaState==highlightC

#define stateD1 displayState==A
#define stateD2 displayState==B
#define stateD3 displayState==C

#define stateA4 agrState==agreement
#define stateA5 agreementState==notAgree
#define stateA6 agreementState==agree

#define p (javaState==highlightB)

mtype = {menu, procA, procB, general,A1,A2,A3,B1,B2,B3};  /* List of all states from fig13*/
mtype menuState;  /* We can have 2 states simultaneously so we need one for menu and one for photo*/
mtype Event;			/* This is used to alternate between different events*/
mtype photoState;


proctype men(chan inp; chan out)
{
	/* The menu frame of the page*/
	do
	:: (menuState==menu && Event==procA) -> menuState=procA;
	:: (menuState==menu && Event==procB) -> menuState=procB;
	:: (menuState==procA) -> menuState=menu;
	:: (menuState==procB) -> menuState=menu;
	od
}

proctype photo(chan inp; chan out)
{
	/* 
		The photo frame of the page.
		When the procA/procB event occurs we step to the next picture
		as long as we are in the right state. Else we switch over.
	*/
	do
	:: (photoState==general && Event==procA) -> photoState=A1;
	:: (photoState==general && Event==procB) -> photoState=B1;
	:: (photoState==A1 && Event==procA) -> photoState=A2;
	:: (photoState==A2 && Event==procA) -> photoState=A3;
	:: (photoState==B1 && Event==procB) -> photoState=B2;
	:: (photoState==B2 && Event==procB) -> photoState=B3;
	:: ((photoState==A1 || photoState==A2 || photoState==A3) && Event==procB) -> photoState=B1;
	:: ((photoState==B1 || photoState==B2 || photoState==B3) && Event==procA) -> photoState=A1;
	:: ((photoState==A1 || photoState==A2 || photoState==A3) && Event==menu) -> photoState=general;
	:: ((photoState==B1 || photoState==B2 || photoState==B3) && Event==menu) -> photoState=general;
	od
}

proctype ev(chan inp; chan out)
{
	/*
		Events to handle state-switching 
		Since promela picks 
		Only use the three events: "menu, procA and procB"
		Could have made a "next"-event, but this would mean to implement an
		extra event, which can be avoided with this model.
	*/
	do
	:: Event = menu;
	:: Event = procA;
	:: Event = procB;
	od
}


init 
{
	/*init the states and events to what we specified by fig13*/
	menuState = menu;		
	Event = procA;
	photoState = general;

	atomic {
		run men();
		run photo();
	};
	run ev()
}
