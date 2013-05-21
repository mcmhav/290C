/**

4. Consider the following speciﬁcation: Computer science graduate program is made up of three 
types of people: professors, graduate students with an advisor and graduate students without an 
advisor. 

D    - Each graduate student can have at most one professor as an advisor. 
D    - A professor can have zero or more advisees. 
D    - Each professor can have research grants which are used to fund his/her advisees. 
D    - A professor can advise students only if he/she has at least one grant. 
D    - An advisee of a professor must be funded by a grant of that professor. 

D    - Professors with research grants oﬀer research seminars to graduate students 
    	when they are looking for advisees. 
D    - If a graduate student has a professor as an advisor, he/she must have taken a 
    	research seminar from that professor.

D    - Write an Alloy model for the above speciﬁcation. 
D    - Write predicates for the following actions: 
D        - hire where a student becomes the advisee of a professor, 
D        - oﬀer where a professor oﬀers a new seminar, 
D        - take where a student takes a seminar. 

D    - Write 3 properties about this speciﬁcation in Alloy
D        - one should fail
D        - one should be correct
D        - explain them in English and check them on your model.

**/

abstract sig Person {}

sig Professor extends Person {
	advisees: set Student,
	grants: set Grant,
	holdsSeminar: set Seminar
}{
	all s: Student | 	((s in advisees) => (s.advisor = this)) &&
								((s in grants.fund))
	all se: Seminar |	(se in holdsSeminar) => (se in grants.seminarFund)
}
sig Student extends Person {
	advisor: lone Professor,
	take: set Seminar
}{
	all p: Professor | (advisor = p) => (this in p.advisees)
	all p: Professor | (advisor = p) => (take in p.holdsSeminar)
}
sig Grant {
	fund: set Student,
	seminarFund: set Seminar
}
sig Seminar {}

pred hire [s: Student, p: Professor]{
	s.advisor = p
}
pred offer [se: Seminar, p: Professor]{
	p.holdsSeminar = p.holdsSeminar + se
}
pred take [se: Seminar, s: Student]{
	s.take = s.take + se
}

/*
Check that all advisees of a profossor has a grant from that professor,
should be correct
*/
assert adviseesGrantCorrectAssert {
	all p: Professor | p.advisees in p.grants.fund
} //check adviseesGrantCorrectAssert

/*
Check if student can be advisee without taking a course of the 
professor they are advisee for, should be correct
*/
assert studentAdviseeCorrectAssert {
	all p: Professor, s: Student | 
			(s in p.advisees) =>
			(s.take in p.holdsSeminar)
} //check studentAdviseeFailAssert

/*
Check if a student can't take a course without being an advisee
Should fail
*/
assert studentSeminarFailAssert {
	all p: Professor, s: Student |
			(s.take in p.holdsSeminar) =>
			(s in p.advisees)
} check studentSeminarFailAssert


//run take for exactly 5 Person, 2 Grant, exactly 5 Seminar
