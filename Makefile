IMAGE := kabaconde/devops-symfony

reset:
	docker-compose exec apache bin/console d:d:d --force
	docker-compose exec apache bin/console d:d:c
	docker-compose exec apache bin/console doctrine:migrations:migrate --no-interaction

update:
	docker-compose exec apache bin/console d:s:u --force

fixtures:
	docker-compose exec apache bin/console doctrine:fixtures:load --no-interaction

test-data: reset fixtures

setup:
	chmod +x ./.travis/main.sh && "./.travis/main.sh"

test:
	chmod +x ./.travis/test.sh && ./.travis/test.sh

install-project:
	chmod +x ./.travis/install-project.sh && ./.travis/install-project.sh

image:
	docker build -t $(IMAGE) ./docker/apache

push-image:
	docker push $(IMAGE)

.PHONY: image push-image test
