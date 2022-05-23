### ECS Cluster ###
resource "aws_ecs_cluster" "prod" {
  name = "28cld-ecs-cluster"
}

###  ECR  Repo ###
resource "aws_ecr_repository" "create_repo" {
  name = "28cld-repo"
}

### Creating Task Definition ###
resource "aws_ecs_task_definition" "task_definition_create" {
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  family                   = "28cld-container"

  container_definitions = jsonencode([
    {
      "name" : "28cld-container",
      "image" : "docker.io/nginx:latest"
      "essential" : true,
      "portMappings" : [
        {
          "containerPort" : 80,
          "protocol" : "tcp"
        }
      ]
    }

  ])
}

data "aws_ecs_task_definition" "get_latest_task_version" {
  task_definition = aws_ecs_task_definition.task_definition_create.family
}


### Creating Service ###
resource "aws_ecs_service" "ecs_service_create" {
  name                               = "28cld-lamp-svc"
  cluster                            = aws_ecs_cluster.prod.name
  task_definition                    = data.aws_ecs_task_definition.get_latest_task_version.arn
  desired_count                      = var.desired_containers
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  health_check_grace_period_seconds  = 60

  load_balancer {
    container_name   = "28cld-container"
    container_port   = 80
    target_group_arn = aws_lb_target_group.tg80.arn


  }

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.app.id]
    subnets          = aws_subnet.application_subnets.*.id
  }
}

### HTTP Target Group ###
resource "aws_lb_target_group" "tg80" {
  name        = "28cld-alb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.create.id
}