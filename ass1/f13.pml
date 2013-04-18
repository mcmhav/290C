/* f13 */

#define state1 menuState==menu
#define state2 menuState==procA
#define state3 menuState==procB

#define stateP1 photoState==general
#define stateP2 photoState==A1
#define stateP3 photoState==A2
#define stateP4 photoState==A3
#define stateP5 photoState==B1
#define stateP6 photoState==B2
#define stateP7 photoState==B3

#define p (menuState==procB)

mtype = {menu, procA, procB, general,A1,A2,A3,B1,B2,B3};  /* List of all states from fig13*/
mtype menuState;  /* We can have 2 states simultaneously so we need one for menu and one for photo*/
mtype Event;			/* This is used to alternate between different events*/
mtype photoState;


proctype men()
{
	/* The menu frame of the page*/
	do
	:: (menuState==menu && Event==procA) -> menuState=procA;
	:: (menuState==menu && Event==procB) -> menuState=procB;
	:: (menuState==procA) -> menuState=menu;
	:: (menuState==procB) -> menuState=menu;
	od
}

proctype photo()
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

proctype ev()
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
