# pate
Packer Ansible Terraform ECS

 * What you have done
 Build, Provision and Push a docker image using packer(dokcer builder) with image configuration done by packer provisioner(Ansible-local) and pushed to docker hub repository.

 Once docker image is pushed to terraform will spin off ecs cluster, AWS RDS and create task definition and start a service to run wordpress image.
 

 * How run your project
   Following two command indside the git repository root directory will get the project running:
   #packer build wordpack.json
   #terraform apply

 * How components interact between each over
   packer provide docker builder and ansible provisioner so iteraction between them was easy to handle. Post provisoner task provided capability to push docker images in hub repository.



 * What problems did you have
   I was building centos7 image on centos 7 instance, was struck with packer shell provisioner failing to run commands. Leter it was found to be bug in packer 
   https://github.com/hashicorp/packer/pull/4186
   https://github.com/hashicorp/packer/issues/4376
   
   Workaround of having ansible pre installed made the things move forward. 

 * How you would have done things to have the best HA/automated architecture
   - Building images should be put in continous integration pipeline using CI tools such as jenkins. So that entire team use and build in similar fashion.
   - Centralize terraform setup using S3 bucket to save tfstate file and dynamo db to prevent simutaneous execution. 
   - Ecs cluster to have autoscaling(I used a ec2 instance only) ELB and multi tier vpc architecture.
   

 * Share with us any ideas you have in mind to improve this kind of infrastructure.
   - Modular terraform setup like:
     https://github.com/arundalal/terraform
   - Introducing ChatOps for executions. We can have errbot integrated with our chat client (Slack etc) to execute packer builds and terraform executions. This would provide teams to collaborate and work over chat groups. Also it would provide a interactive interface to both packer and terraform, which they currently lack.




```
Tomorrow we want to put this project in production. What would be your advices and choices to achieve that.
Regarding the infrastructure itself and also external services like the monitoring, ...
...
- A CI(jenkins) to achieve automated build execution and a private conatiner repository for storing baked containers.
- Multi-tier VPC infrastructure with autoscaling and Load balanced services. We can have separate vpcs for database and ECS cluster images.
- Monitoring set up would have
  1) Server Monitoring like nagios
  2) Container Monitoring like Prometheus
