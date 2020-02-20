# app

# The Json file of the template to be ran. Also grabs the helloworld.js from the ecr repo on aws
data "template_file" "myapp-task-definition-template" {
  template               = "${file("templates/app.json.tpl")}"
  vars = {
    REPOSITORY_URL = "${replace("${aws_ecr_repository.myapp.repository_url}", "https://", "")}"
  }
}

# The name and rescuource of the cluster
resource "aws_ecs_cluster" "example-cluster" {
    name = "example-cluster"
}

# The task that will be ran o the cluster and the container information
resource "aws_ecs_task_definition" "myapp-task-definition" {
  family                = "myapp"
  container_definitions = "${data.template_file.myapp-task-definition-template.rendered}"
}

#The load balancer that handles the traffic of the server & other server config info
resource "aws_elb" "myapp-elb" {
  name = "myapp-elb"

  listener {
    instance_port = 3000
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 30
    target = "HTTP:3000/"
    interval = 60
  }

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  subnets = ["${aws_subnet.main-public-1.id}","${aws_subnet.main-public-2.id}"]
  security_groups = ["${aws_security_group.myapp-elb-securitygroup.id}"]

  tags = {
    Name = "myapp-elb"
  }
}

# The AWS service defines the role and service to be attached to the Cluster
# the policy is important because it gives the app permission to run the tasks
resource "aws_ecs_service" "myapp-service" {
  name                = "myapp"
  cluster             = "${aws_ecs_cluster.example-cluster.id}"
  task_definition     = "${aws_ecs_task_definition.myapp-task-definition.arn}"
  desired_count       = 1
  iam_role            = "${aws_iam_role.ecs-service-role.arn}"
  depends_on          = ["aws_iam_policy_attachment.ecs-service-attach1"]

  load_balancer {
    elb_name = "${aws_elb.myapp-elb.name}"
    container_name = "myapp"
    container_port = 3000
  }
  lifecycle { ignore_changes = ["task_definition"] }
}
