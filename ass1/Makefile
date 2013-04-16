SPIN	= /cs/faculty/bultan/public_html/courses/290-S13/bin/spin
RMFILES = pan.* *.trail f13 f18

clean:
	rm -f $(RMFILES)
	clear

push:
	rm -f $(RMFILES)
	git add -u && git commit -m "autopush" && git push

run13:	
	$(SPIN) -a f13.pml
	gcc pan.c -o f13
	clear
	./f13

run18:
	$(SPIN) -a f18.pml
	gcc pan.c -o f18
	clear
	./f18
