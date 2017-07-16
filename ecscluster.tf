provider "aws" {
    access_key = ""
    secret_key = ""
    region = "us-east-1"
}

resource "aws_ecs_cluster" "ecs" {
    name = "webcluster"
}

resource "aws_instance" "ecsnode" {
    count = 1
    ami = "ami-04351e12"
    instance_type = "t2.small"
    key_name = "arun"
    vpc_security_group_ids = ["sg-45fab839"]
    associate_public_ip_address = true
    iam_instance_profile = "ecsInstanceRole"
    user_data = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.ecs.name} > /etc/ecs/ecs.config"
    tags {
    Name = "ECS CONTAINER SERVICE"
    Creator = "Terraform"
    }
}

resource "aws_db_instance" "wordrds" {
  allocated_storage    = 10
  storage_type         = "gp2" 
  engine               = "mysql"
  engine_version       = "5.6.27"
  instance_class       = "db.t2.micro"
  identifier           = "wordpresrds"
  name               = "wpdata"
  username             = "wpuser"
  password             = "password"
  parameter_group_name = "default.mysql5.6"
  vpc_security_group_ids =  ["sg-45fab839"]
}

resource "aws_ecs_task_definition" "webservice" {
    family = "webservice"
    container_definitions = "${file("web.json")}"
}


resource "aws_ecs_service" "wordpress" {
  name            = "wordpress"
  cluster         = "${aws_ecs_cluster.ecs.id}"
  task_definition = "${aws_ecs_task_definition.webservice.arn}"
  desired_count   = 1
  
}