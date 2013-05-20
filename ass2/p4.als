/**

4. Consider the following speciﬁcation: Computer science graduate program is made up of three 
types of people: professors, graduate students with an advisor and graduate students without an 
advisor. 

    - Each graduate student can have at most one professor as an advisor. 
    - A professor can have zero or more advisees. 
    - Each professor can have research grants which are used to fund his/her advisees. 
    - A professor can advise students only if he/she has at least one grant. 
    - An advisee of a professor must be funded by a grant of that professor. 

Professors with research grants oﬀer research seminars to graduate students when they are looking
 for advisees. If a graduate student has a professor as an advisor, he/she must have taken a 
research seminar from that professor.

    - Write an Alloy model for the above speciﬁcation. 
    - Write predicates for the following actions: 
        - hire where a student becomes the advisee of a professor, 
        - oﬀer where a professor oﬀers a new seminar, 
        - take where a student takes a seminar. 
    - Write 3 properties about this speciﬁcation in Alloy (at least one of them should fail and at least 
	one should be correct), explain them in English and check them on your model.

**/

abstract sig Person {
}{
	//all s: Student, p: Professor | (s.advisor = p) => (p.advisees = s)
	//all s: Student, p: Professor | (p.advisees = s) => (s.advisor = p)
	//all s: Student, p: Professor | p.advisees = s 
	//all p: Professor, pa: p.advisees, s: Student | pa = s
	//all p:Professor, s:Student | p.advisees = ~s.advisor
	//all x0:Professor | Student.advisor  = ~x0.advisees
//	Professor.advisees = ~Student.advisor
}

sig Professor extends Person {
	advisees: set Student,
	//advisees: students set -> set students
}{
//	all s:Students | s.advisor in ad
//	all s: Student | (advisees = s) => (s.advisor = this)
	//all s: Student | (s.advisor = this) => (advisees = s)
	//all s: Student | this = s.advisor
	//all s: Student | (s.advisor = this) => (advisees = s)
	//all s: Student | (advisees = s) => (s.advisor = this)
	all s: Student | (s in advisees) => (s.advisor = this)
}

sig Student extends Person {
	advisor: lone Professor
}{
	all p: Professor | (advisor = p) => (this in p.advisees)
	//all p: Professor | (p.advisees = this) => (advisor = p)
	//all p: Professor | (p.advisees = this) => (advisor = p)
	//all p: Professor | (this in p.advisees) => (advisor = p)
}


run {} for exactly 5 Person
