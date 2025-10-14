
###############################
# IAM Role for ECS Task
###############################
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "AmazonECSTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

###############################
# Security Group for ALB
###############################
resource "aws_security_group" "alb_sg" {
  name        = "onov8-alb-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "onov8-alb-sg"
  }
}

###############################
# Application Load Balancer
###############################
resource "aws_lb" "onov8_alb" {
  name               = "onov8-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.alb_sg.id]

  enable_deletion_protection = false

  tags = {
    Name = "onov8-alb"
  }
}

###############################
# ECR Repository
###############################
resource "aws_ecr_repository" "onov8_repo" {
  name = "onov8-app"
}

###############################
# ECS Cluster
###############################
resource "aws_ecs_cluster" "onov8_cluster" {
  name = "onov8-cluster"
}

###############################
# ECS Task Definition
###############################
resource "aws_ecs_task_definition" "onov8_task" {
  family                   = "onov8-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "onov8-app"
      image     = "${aws_ecr_repository.onov8_repo.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

###############################
# ECS Service
###############################
resource "aws_ecs_service" "onov8_service" {
  name            = "onov8-service"
  cluster         = aws_ecs_cluster.onov8_cluster.id
  task_definition = aws_ecs_task_definition.onov8_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    assign_public_ip = true
    security_groups = [aws_security_group.alb_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.onov8_tg.arn
    container_name   = "onov8-app"
    container_port   = 80
  }
}

###############################
# ALB Target Group
###############################
resource "aws_lb_target_group" "onov8_tg" {
  name     = "onov8-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  target_type = "ip"
}
