
output "ec2_ip_addr" {
  description = "The public_ip of the instance"
  value       = aws_instance.minaInstance.public_ip
}
output "ec2_dns" {
  description = "The public_dns of the instance"
  value       = aws_instance.minaInstance.public_dns
}
