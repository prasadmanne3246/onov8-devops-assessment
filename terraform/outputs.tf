# output "alb_dns_name" {
#   value = aws_lb.onov8_alb.dns_name
# }

output "cluster_name" {
  value = aws_ecs_cluster.onov8_cluster.name
}

output "service_name" {
  value = aws_ecs_service.onov8_service.name
}

output "task_definition" {
  value = aws_ecs_task_definition.onov8_task.family
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}
