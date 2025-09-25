INFISICAL_ENV ?= prod
COMPOSE_FILE ?= docker-compose.yml
INFISICAL_PROJECT_ID ?= 178fffd9-36a5-41c7-8c9f-5524ca51dbfd


up: pull
	infisical run --env=$(INFISICAL_ENV) --projectId=$(INFISICAL_PROJECT_ID) -- docker compose -f $(COMPOSE_FILE) up -d


