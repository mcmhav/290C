#define TRUE 1
#define FALSE 0

#define rla (reqL==TRUE)
#define rs (reqS==TRUE)
#define c (chec==TRUE)
#define rl (riskL==TRUE)
#define rh (riskH==TRUE)
#define a (app==TRUE)
#define d (den==TRUE)

mtype = {requestLarge, requestSmall, check, riskLow, riskHigh, approved, denied} 

chan cusomter2Approver = [10] of {mtype, byte};
chan approver2Customer = [10] of {mtype, byte};
chan approver2risk = [10] of {mtype, byte};
chan risk2approver = [10] of {mtype, byte};

bool reqL= FALSE;
bool reqS= FALSE;
bool chec= FALSE;
bool riskL= FALSE;
bool riskH= FALSE;
bool app= FALSE;
bool den= FALSE;

active proctype customer () { 
    if
        :: cusomter2Approver ! requestSmall(1);
        atomic {approver2Customer ? approved(_); app=TRUE};
        :: cusomter2Approver ! requestLarge(1);
        if
            :: atomic {approver2Customer ? approved(_); app=TRUE};
            :: atomic {approver2Customer ? denied(_); den=TRUE};
        fi;
    fi;
}

active proctype loanApprover () {
    if
        :: atomic {cusomter2Approver ? requestSmall(_); reqS=TRUE};
        approver2Customer ! approved(1);
        :: atomic {cusomter2Approver ? requestLarge(_); reqL=TRUE};
        approver2risk ! check(1);
        if
            :: atomic {risk2approver ? riskLow(_); riskL=TRUE};
            approver2Customer ! approved(1);
            :: atomic {risk2approver ? riskHigh(_); riskH=TRUE};
            approver2Customer ! denied(1);
        fi;
    fi;
}

active proctype riskAsserssor () {
    atomic {approver2risk ? check(_); chec=TRUE};
    if
        :: risk2approver ! riskLow(1)
        :: risk2approver ! riskHigh(1)
    fi;
}

/*
never  {    // ! ([] (rs -> <> a)) 
T0_init:
    do
    :: (! ((a)) && (rs)) -> goto accept_S4
    :: (1) -> goto T0_init
    od;
accept_S4:
    do
    :: (! ((a))) -> goto accept_S4
    od;
}


never  {    // ! (<>(a || d)) 
accept_init:
T0_init:
    do
    :: (! ((a || d))) -> goto T0_init
    od;
}
*/

never  {    // ! ([](rla -> <>(rl || rh))) 
T0_init:
    do
    :: (! ((rl || rh)) && (rla)) -> goto accept_S4
    :: (1) -> goto T0_init
    od;
accept_S4:
    do
    :: (! ((rl || rh))) -> goto accept_S4
    od;
}
