SPIN	= /cs/faculty/bultan/public_html/courses/290-S13/bin/spin
RMFILES = pan.* *.trail hw4a3

clean:
	rm -f $(RMFILES)
	clear

push:
	rm -f $(RMFILES)
	git add -u && git commit -m "autopush" && git push

run:
	spin -a hw4a3.pml
	gcc pan.c -o hw4a3
	clear
	./hw4a3