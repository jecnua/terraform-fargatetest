resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_ecs_cluster" "test_ecs_cluster" {
  name = "test-FARGATE"
}

resource "aws_ecs_task_definition" "test_task_definition" {
  family                   = "test_task_definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = <<DEFINITION
[
  {
    "cpu": 256,
    "essential": true,
    "image": "library/nginx:latest",
    "memory": 512,
    "name": "nginx",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "test_ecs_service" {
  name            = "test-FARGATE-service"
  cluster         = "${aws_ecs_cluster.test_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.test_task_definition.arn}"
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.allow_all.id}"]
    subnets         = ["${var.subnet_id}"]
  }
}
