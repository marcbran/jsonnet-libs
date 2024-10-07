.PHONY: test build deliver

test:
	@$(MAKE) -C test run

build:
	@./scripts/build.sh

deliver: test build
