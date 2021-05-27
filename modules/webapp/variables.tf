variable "server_port" {
  description = "React app listening port"
  type        = number
  default     = 5000
}

variable "alb_port" {
  description = "ALB listen port"
  default     = 80
  type        = number
}

variable "ami" {
  description = "AMI Id"
  type        = string
  default     = ""
}
