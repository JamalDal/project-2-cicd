
# CICD project-2

First of all, make a passwordless connection between all servers. To to do so, take help from project 1 of cicd. 


## Documentation

### Getting Jenkins sserver ready

```bash
yum install java* -y
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins
systemctl start jenkins
syatemctl enable jenkins
yum install git 
yum install docker
```
Now intergrate Jenkins and GitHub
Add webhook
```bash
http://3.80.221.121:8080/github-webhook/
``` 

Add Public Over SSH plugins
and then add Jenkins and Ansible servers

Build >> Add build > select “Send files or execute commands over SSH” Select Jenkins Exec command
On Jenkins
```bash
rsync -avh /var/lib/jenkins/workspace/project-2-cicd/Deckertle root@172.31.57.7:/opt
```

On Ansible 
```bash
cd /opt
docker image build - $JOB_NAME:version1.$BUILD_ID .
docker image tag  $JOB_NAME:version1.$BUILD_ID jamaldal/$JOB_NAME:version1.$BUILD_ID
docker image tag $JOB_NAME:version1.$BUILD_ID jamaldal/$JOB_NAME:latest
docker image push jamaldal/$JOB_NAME:version1.$BUILD_ID
docker image push jamaldal/$JOB_NAME:latest
docker imade rmi $JOB_NAME:version1.$BUILD_ID jamaldal/$JOB_NAME:version1.$BUILD_ID
jamaldal/$JOB_NAME:latest
```
Note: Here $JOB_NAME and $BUILD_ID are Jenkins variable

At Ansible server create a sourcecode folder and then playbook in it

```bash
mkdir sourcecode
cd  /sourcecode >> vi docker.yml
```

Docker file
```bash
hosts: all
 tasks:
	- name: stop container
	  shell: docker container stop project-2-cicd 
	- name: remove container
	  shell: docker container rm project-2-cicd 
	- name: remove docker image
	  shell: docker image rm jamaldal/project-2-cicd 
	- name: create container
	  shell: docker container run -itd —name project-2-cicd -p 8000:80 jamaldal/project-2-cicd-job
```

Post-build Actions > Send build artifacts over SSH Select ansible Exec command

```bash
ansible-playbook /sourcecode/docker.yml
```

```bash
Job Done!
```


