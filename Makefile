IMAGE := kabaconde/symfony-devops

reset:
	docker-compose exec apache bin/console d:d:d --force
	docker-compose exec apache bin/console d:d:c
	docker-compose exec apache bin/console doctrine:migrations:migrate --no-interaction

update:
	docker-compose exec apache bin/console d:s:u --force

install:
	docker-compose exec apache composer install

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

build-image:
	docker build -t $(IMAGE):travis --file `pwd`/docker/apache/Dockerfile.prod `pwd`

slim-image1:
	docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock dslim/docker-slim build $(IMAGE):latest

slim-image:
	docker save $(IMAGE):latest | sudo docker-squash -t $(IMAGE):latest-slim | docker load

.PHONY: image push-image test
