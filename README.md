# Jenkins CI


### Docker image
See https://registry.hub.docker.com/_/jenkins/ for details.

#### Build new image

	docker build -t jenkins:test-1  .

Start Jenkins with a *peristent volume*:

    docker run --rm --privileged --name myjenkins -p 8080:8080 -v /var/jenkins_home jenkins:test-1


Open in browser: 

	open http://$(boot2docker ip 2>/dev/null):8080/

### Backing up data

If you bind mount in a volume - you can simply back up that directory (which is jenkins_home) at any time.

If your volume is inside a container - you can use docker cp $ID:/var/jenkins_home command to extract the data.

### Get a list of plugins
http://<HOST>:<PORT>/pluginManager/api/json?tree=plugins[shortName,version]&pretty=true

## References
http://www.jayway.com/2015/03/14/docker-in-docker-with-jenkins-and-supervisord/

##TODO:

docker -v /var/run/docker.sock:/var/run/docker.sock

~~~
service=$JOB_NAME
branch=$(echo $GIT_BRANCH | cut -d/ -f 2)

docker run --rm \
  -v $(pwd):/src \
  -v /var/run/docker.sock:/var/run/docker.sock \
  centurylink/golang-builder \
  $service:$branch 
~~~