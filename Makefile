.DEFAULT_GOAL := help

COMPOSE := docker compose
DEV_FILES := -f docker-compose.yml -f docker-compose.dev.yml

.PHONY: help up down restart ps logs config test clean

help:
	@echo "VulnSight Development Commands"
	@echo ""
	@echo "make up       Start local infrastructure"
	@echo "make down     Stop containers"
	@echo "make restart  Restart containers"
	@echo "make ps       Show container status"
	@echo "make logs     Show service logs"
	@echo "make config   Validate Compose configuration"
	@echo "make test     Run infrastructure health checks"
	@echo "make clean    Stop containers and delete local volumes"

up:
	$(COMPOSE) $(DEV_FILES) up -d

down:
	$(COMPOSE) $(DEV_FILES) down

restart:
	$(COMPOSE) $(DEV_FILES) restart

ps:
	$(COMPOSE) $(DEV_FILES) ps

logs:
	$(COMPOSE) $(DEV_FILES) logs -f

config:
	$(COMPOSE) $(DEV_FILES) config --quiet

test:
	$(COMPOSE) $(DEV_FILES) exec -T postgres \
		sh -c 'pg_isready -U "$$POSTGRES_USER" -d "$$POSTGRES_DB"'
	$(COMPOSE) $(DEV_FILES) exec -T redis redis-cli ping

clean:
	$(COMPOSE) $(DEV_FILES) down -v
