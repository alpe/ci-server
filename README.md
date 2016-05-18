# Sandbox for basic continuous integration/ deployment system
## Preparation
```
docker pull jenkins:alpine
docker pull registry:2.4
```
## Start
```
docker-compose up
```
## Access

```
open http://$(boot2docker ip):8080/
```

Resource:
* https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/
