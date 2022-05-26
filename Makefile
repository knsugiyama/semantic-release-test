SHELL=/bin/bash

.PHONY := init dev sh help
.DEFAULT_GOAL := help

all:

init: ## build & run
	@docker compose build
	@docker compose run --rm app

dev: ## docker-compose up
	@docker compose down app
	@docker compose up app

sh: ## exec sh
	@docker compose up --no-start app
	@docker compose start app
	@docker compose exec app sh

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
