# Jenkins CI
Deprecated:
https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/

## Getting started

build keys:
~~~
 cd ssh
 openssl genrsa -out id_rsa 2048
 openssl rsa -in id_rsa -pubout -out id_rsa.pub
~~~
start ssh-agent on server:
~~~
eval `ssh-agent -s`
ssh-add
~~~
## Prepare fleet command
~~~
export FLEETCTL_TUNNEL=46.101.190.178
~~~


### References
Compose CLI: https://docs.docker.com/compose/cli/
Compose yml: https://docs.docker.com/compose/yml
Docker registry server: https://github.com/docker/distribution/blob/master/docs/deploying.md

### Docker images
Jenkins base image: https://registry.hub.docker.com/_/jenkins/ for details.

#### Build new custom image

	docker build -t jenkins:latest  .

Start Jenkins and local docker registry:

	docker-compose up

Manual start Jenkins with a *peristent volume*:

    docker run --privileged --name myjenkins -p 8080:8080 -v /var/jenkins_home jenkins:latest


Open in browser: 

	open http://$(boot2docker ip 2>/dev/null):8080/

Stop Jenkins:

	docker stop myjenkins

Connect to container:

	docker exec -it myjenkins bash	

### Backing up data

If you bind mount in a volume - you can simply back up that directory (which is jenkins_home) at any time.

If your volume is inside a container - you can use `docker cp $ID:/var/jenkins_home command` to extract the data.

### Get a list of installed Jenkins plugins
http://<HOST>:<PORT>/pluginManager/api/json?tree=plugins[shortName,version]&pretty=true

## References
http://www.jayway.com/2015/03/14/docker-in-docker-with-jenkins-and-supervisord/
[Docker in Docker](https://github.com/jpetazzo/dind)

## TODO
 - [ ] Domain
 - [ ] TLS for registry

##Notes

### CI Workflow
checkout --> 
go vet
go test -v ./... 
go lint
go coverage
-->

docker -v /var/run/docker.sock:/var/run/docker.sock

~~~
service=$JOB_NAME
branch=$(echo $GIT_BRANCH | cut -d/ -f 2)
gobuilder_image=registry:5000/go_builder_image

echo "build image"
docker run --rm \
  -v $(pwd):/src \
  -v /var/run/docker.sock:/var/run/docker.sock \
  $gobuilder_image \
  $service:$branch 


echo "smoke test image"
CONTAINER_ID=$(docker run -d -p 127.0.0.1:8090:8080 $service:$branch)

curl --silent --max-time 10 --write-out "%{http_code}" \
--output /dev/null  http://127.0.0.1:8090/

echo "clean up after test"
docker stop $CONTAINER_ID
docker rm -v $CONTAINER_ID

echo "tag + upload image"
docker tag $service:$branch registry:5000/$service:$branch-$BUILD_NUMBER
docker push registry:5000/$service:$branch-$BUILD_NUMBER
~~~
