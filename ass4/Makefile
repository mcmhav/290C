SPIN	= /cs/faculty/bultan/public_html/courses/290-S13/bin/spin
RMFILES = pan.* *.trail hw4a3e* test

clean:
	rm -f $(RMFILES)
	clear

push:
	rm -f $(RMFILES)
	git add -u && git commit -m "autopush" && git push

run:
	spin -a hw4a3Loan.pml
	gcc pan.c -o hw4a3eLoan
	clear
	./hw4a3eLoan

runa:
	spin -a hw4a3LoanAsync.pml
	gcc pan.c -o hw4a3eLoanAsync
	clear
	./hw4a3eLoanAsync

runt:
	spin -a hw4a3Travel.pml
	gcc pan.c -o hw4a3eTravel
	clear
	./hw4a3eTravel

runta:
	spin -a hw4a3TravelAsync.pml
	gcc pan.c -o hw4a3eTravelAsync
	clear
	./hw4a3eTravelAsync

runtest:
	spin -a test.pml
	gcc pan.c -o test
	clear
	./test