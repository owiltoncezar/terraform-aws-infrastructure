output "vpc_id" {
  description = "The ID of the default VPC"
  value       = data.aws_vpc.default.id
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.ec2_instance.id
}
