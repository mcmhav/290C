#define TRUE 1
#define FALSE 0

#define t (tim==TRUE)
#define b (bu==TRUE)
#define c (can==TRUE)
#define o (con==TRUE)

mtype = {getQuote, quote, timeOut, buy, cancel, confirm} 

chan travelA2air = [0] of {mtype, byte};
chan air2travelA = [0] of {mtype, byte};

bool tim= FALSE;
bool bu= FALSE;
bool can= FALSE;
bool con= FALSE;

active proctype travelA () {
    travelA2air ! getQuote(1);
    air2travelA ? quote(_);
    if
        :: travelA2air ! buy(1);
        atomic{air2travelA ? confirm(_); con=TRUE};
        :: travelA2air ! cancel(1);
        :: atomic{air2travelA ? timeOut(_); tim=TRUE};
    fi;
}

active proctype air () {
    travelA2air ? getQuote(_);
    air2travelA ! quote(1);
    if
        :: atomic{travelA2air ? buy(_); bu=TRUE};
        air2travelA ! confirm(1);
        :: atomic{travelA2air ? cancel(_); can=TRUE};
        :: air2travelA ! timeOut(1);
    fi;
}

/*
never  {    // ! ([] (b -> <>(o))) 
T0_init:
    do
    :: (! ((o)) && (b)) -> goto accept_S4
    :: (1) -> goto T0_init
    od;
accept_S4:
    do
    :: (! ((o))) -> goto accept_S4
    od;
}
never  {    // ! (<> (o || c || t)) 
accept_init:
T0_init:
    do
    :: (! ((o || c || t))) -> goto T0_init
    od;
}
*/

never  {    //! ([] (t -> !(<>(c || o)))) 
T0_init:
    do
    :: atomic { ((c || o) && (t)) -> assert(!((c || o) && (t))) }
    :: ((t)) -> goto T0_S4
    :: (1) -> goto T0_init
    od;
T0_S4:
    do
    :: atomic { ((c || o)) -> assert(!((c || o))) }
    :: (1) -> goto T0_S4
    od;
accept_all:
    skip
}
