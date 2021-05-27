output "web_app_url" {
  value = module.react_app.alb_dns_name
}

output "ssh_key" {
  value = module.react_app.ssh_private_key
}
