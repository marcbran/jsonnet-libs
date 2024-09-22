.PHONY: deliver

deliver:
	@$(MAKE) -C grafonnet-layout deliver
	@$(MAKE) -C grafonnet-query deliver
	@$(MAKE) -C jsonnet deliver
	@$(MAKE) -C prom2jsonnet deliver
	@$(MAKE) -C promql deliver
