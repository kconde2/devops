reset:
	docker-compose exec apache bin/console d:d:d --force
	docker-compose exec apache bin/console d:d:c
	docker-compose exec apache bin/console doctrine:migrations:migrate --no-interaction

update:
	docker-compose exec apache bin/console d:s:u --force

fixtures:
	docker-compose exec apache bin/console doctrine:fixtures:load --no-interaction

test-data: reset fixtures
