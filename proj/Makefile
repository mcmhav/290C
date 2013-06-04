SPIN	= /cs/faculty/bultan/public_html/courses/290-S13/bin/spin
RMFILES = *.log

clean:
	rm -f $(RMFILES)
	clear

push:
	rm -f $(RMFILES)
	git add -u && git commit -m "autopush" && git push

mrun:
	clear
	ruby railsAR2alloy_dynamic.rb -o out/mephistoModel.als apps/mephisto/models

rrun:
	clear
	ruby railsAR2alloy_dynamic.rb -o out/redmineModel.als apps/redmine-2.3/models
