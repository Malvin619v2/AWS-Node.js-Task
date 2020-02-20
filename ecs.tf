# cluster

# Defines the cluster name to be ran
resource "aws_ecs_cluster" "example-Cluster" {
  name = "example-cluster"
}

# Manages the launch configurations of the instance and implements the right settings
resource "aws_launch_configuration" "ecs-example-launchconfig" {
  name                  = "ecs-launchconfig"
  image_id              = "${lookup(var.ecs_amis, var.aws_region)}"
  instance_type         = "${var.ecs_instance_type}"
  iam_instance_profile  = "{aws_iam_instance_profile.ecs-ec2-role.id}"
  security_groups       = ["${aws_security_group.ecs-securitygroup.id}"]
  user_data             = "#!/bin/bash\necho 'ECS_CLUSTER=example-cluster' > /etc/ecs/ecs.config\nstart ecs"

  lifecycle {
    create_before_destroy = true
  }
}

# Manages the number of instances to be running
resource "aws_autoscaling_group" "ecs-example-autoscaling" {
  name                   = "ecs-exaple-autscaling"
  vpc_zone_identifier    = ["${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}"]
  launch_configuration   = "${aws_launch_configuration.ecs-example-launchconfig.name}"
  min_size               = 1
  max_size               = 1

  lifecycle {
    create_before_destroy = true
  }
}
