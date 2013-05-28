abstract sig user {
	access: set resource
}
abstract sig resource {
	assPatient: one patient,
}

sig patient extends user {
	assHealthRecord: one healthRecord,
	assMedicalBill: lone medicalBill,
}{
	access = assHealthRecord + assMedicalBill
}
sig doctor extends user {}{
	all hr:healthRecord | (hr in access)
	no medicalBill
}
sig administrator extends user {}{
	all hr:healthRecord | (this in hr.administrators) => (hr in access)
	all mb:medicalBill | (this in mb.administrators) => (mb in access)
}
sig healthRecord extends resource {
	doctors: some doctor,
	administrators: some administrator
}{
	all p:patient | (this in p.assHealthRecord) => (assPatient = p)
}
sig medicalBill extends resource {
	administrators: some administrator
}{
	all p:patient | (this in p.assMedicalBill) => (assPatient = p)
}

pred accessResourceP1 [u: user, r: resource] {
	all hr:healthRecord, d:doctor | (hr in d.access) => (d in hr.doctors)
	(r in u.access)
}
pred accessResourceP2 [u: user, r: resource] {
	(r in u.access)
}

assert doctorAccessBill {
	no d:doctor, mb:medicalBill | (mb in d.access)
} //check doctorAccessBill
assert patientOnlyAccessOwnHealthRecord {
	no p:patient, hr:healthRecord | 	
		(p.assHealthRecord not in p.access) ||
		((p.assHealthRecord = hr) and (hr not in p.access))
} check patientOnlyAccessOwnHealthRecord
assert adminOnlyAccessOwnResources {
	no a:administrator, hr:healthRecord |
		(hr in a.access) and (a not in hr.administrators)
	no a:administrator, mr:medicalBill |
		(mr in a.access) and (a not in mr.administrators)
} //check adminOnlyAccessOwnResources

//run {} for 4 user, 3 resource
