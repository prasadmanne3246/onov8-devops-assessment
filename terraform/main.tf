#############################################
# ONOV8 DevOps Project - main.tf (Final)
# Region: ap-south-1 (Mumbai)
# Author: Jeevan
#############################################

# ------------------------------
# Networking - VPC, Subnet, Route, SG
# ------------------------------

resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "onov8-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "onov8-public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "onov8-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "onov8-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "ecs_sg" {
  vpc_id      = aws_vpc.main_vpc.id
  name        = "onov8-ecs-sg"
  description = "Allow incoming traffic for app"

  ingress {
    from_port   = 3000
    to_port     = 3000
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
    Name = "onov8-ecs-sg"
  }
}

# ------------------------------
# ECR Repository (for app image)
# ------------------------------

resource "aws_ecr_repository" "onov8_app" {
  name                 = "onov8-app"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  tags = {
    Name = "onov8-app"
  }
}

# ------------------------------
# ECS Cluster, Task, Service
# ------------------------------

resource "aws_ecs_cluster" "onov8_cluster" {
  name = "onov8-cluster"
}

# IAM Role for ECS Tasks
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Effect = "Allow"
    }]
  })
}

# Attach ECS Task Execution Policy
resource "aws_iam_role_policy_attachment" "ecs_task_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "onov8_task" {
  family                   = "onov8-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "onov8-app"
      image = "165672952252.dkr.ecr.ap-south-1.amazonaws.com/onov8-app:latest"
      essential = true

      portMappings = [{
        containerPort = 3000
        hostPort      = 3000
      }]
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "onov8_service" {
  name            = "onov8-service"
  cluster         = aws_ecs_cluster.onov8_cluster.id
  task_definition = aws_ecs_task_definition.onov8_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public_subnet.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  depends_on = [
    aws_ecs_task_definition.onov8_task
  ]
}
