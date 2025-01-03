up:
	docker compose up -d

down:
	docker compose down

build:
	docker compose build

rebuild:
	docker compose build --no-cache

enter backend:
	docker exec -it food-diary-backend bash