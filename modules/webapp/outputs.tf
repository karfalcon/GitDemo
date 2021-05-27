output "alb_dns_name" {
  description = "The domain name of the load balancer"
  value       = aws_lb.alb.dns_name
}

output "ssh_private_key" {
  value = "${tls_private_key.ec2_private_key.private_key_pem}"
}
