.PHONY: test it build deliver

test:
	@$(MAKE) -C test run

it:
	@$(MAKE) -C it run

build:
	@./scripts/build.sh

deliver: test it build
