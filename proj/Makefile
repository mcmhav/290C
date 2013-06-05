SPIN	= /cs/faculty/bultan/public_html/courses/290-S13/bin/spin
RMFILES = *.log

ifeq (push,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  MESSAGE := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(MESSAGE):;@:)
endif

clean:
	rm -f $(RMFILES)
	clear

push:
	rm -f $(RMFILES)
	git commit -am $(MESSAGE) && git pull && git push

mrun:
	clear
	ruby railsAR2alloy_dynamic.rb -o out/mephistoModel.als apps/mephisto/models

rrun:
	clear
	ruby railsAR2alloy_dynamic.rb -o out/redmineModel.als apps/redmine-2.3/models
