# Devops

## Tools

```shell
docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock dslim/docker-slim build kabaconde/devops-symfony
```

```shell
docker run -d -p 80:80 --name=devops kabaconde/devops:latest
```

```shell
docker ps
```

```shell
docker exec -it <container-id> bash
```
