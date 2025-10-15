output "ecs_cluster_name" {
  value = aws_ecs_cluster.onov8_cluster.name
}

output "subnet_id" {
  value = aws_subnet.public_subnet.id
}
