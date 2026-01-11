INFISICAL_ENV ?= prod
COMPOSE_FILE ?= docker-compose.yml
INFISICAL_PROJECT_ID ?= 178fffd9-36a5-41c7-8c9f-5524ca51dbfd

# Development commands
dev: dev-pull
	infisical run --env=dev --projectId=$(INFISICAL_PROJECT_ID) -- docker compose -f docker-compose.dev.yml up --build

dev-rebuild:
	docker compose -f docker-compose.dev.yml down --volumes --remove-orphans
	docker compose -f docker-compose.dev.yml build --no-cache --pull
	infisical run --env=dev --projectId=$(INFISICAL_PROJECT_ID) -- docker compose -f docker-compose.dev.yml up

dev-clean-rebuild:
	docker compose -f docker-compose.dev.yml down --volumes --remove-orphans
	docker system prune -f
	docker compose -f docker-compose.dev.yml build --no-cache --pull
	infisical run --env=dev --projectId=$(INFISICAL_PROJECT_ID) -- docker compose -f docker-compose.dev.yml up

dev-pull:
	docker compose -f docker-compose.dev.yml pull

dev-down:
	docker compose -f docker-compose.dev.yml down

dev-logs:
	docker compose -f docker-compose.dev.yml logs -f

dev-restart:
	docker compose -f docker-compose.dev.yml restart

# Production commands  
pull:
	docker compose pull

up: pull
	infisical run --env=$(INFISICAL_ENV) --projectId=$(INFISICAL_PROJECT_ID) -- docker compose -f $(COMPOSE_FILE) up -d

down:
	docker compose -f $(COMPOSE_FILE) down

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

restart:
	docker compose -f $(COMPOSE_FILE) restart

# Utility commands
clean:
	docker system prune -f
	docker volume prune -f

# Clean everything including volumes (nuclear option)
dev-clean-all:
	docker-compose -f docker-compose.dev.yml down --volumes --remove-orphans
	docker system prune -f
	docker volume prune -f

# Clean rebuild with volume reset
dev-clean-rebuild:
	docker-compose -f docker-compose.dev.yml down --volumes --remove-orphans
	docker system prune -f
	docker compose -f docker-compose.dev.yml build --no-cache --pull
	infisical run --env=dev --projectId=$(INFISICAL_PROJECT_ID) -- docker compose -f docker-compose.dev.yml up

.PHONY: dev dev-rebuild dev-clean-rebuild dev-pull dev-down dev-logs dev-restart pull up down logs restart clean dev-clean-all


