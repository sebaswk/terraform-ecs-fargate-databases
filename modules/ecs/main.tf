resource "aws_ecs_cluster" "cluster" {
  name = "EcsCluster${var.project_name}"
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "Task${var.project_name}"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {
      "name" : "${var.project_name}",
      "image" : "${var.app_image}",
      "cpu" : 1024,
      "memory" : 3072,
      "networkMode" : "awsvpc",
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-create-group" : "true",
          "awslogs-group" : "/ecs/${var.app_logs}",
          "awslogs-region" : "us-east-1",
          "awslogs-stream-prefix" : "ecs"
        }
      },
      "portMappings" : [
        {
          "containerPort" : 80,
          "hostPort" : 80
        }
      ]
    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_service" "service" {
  name                   = "Service${var.project_name}"
  cluster                = aws_ecs_cluster.cluster.id
  task_definition        = aws_ecs_task_definition.task_definition.arn
  desired_count          = var.app_count
  enable_execute_command = true
  launch_type            = "FARGATE"

  network_configuration {
    security_groups  = var.security_group_asg_cluster
    subnets          = var.subnets_asg_cluster
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.tg_service
    container_name   = "${var.project_name}"
    container_port   = var.target_group_port
  }

  depends_on = [var.alb_listener_ecs, aws_iam_role_policy_attachment.ecs_task_execution_role]
}
