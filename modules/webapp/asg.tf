data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}
resource "aws_security_group" "lc_sg" {
  name = "webserver_sg"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "ec2_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "react-instance-key"
  public_key = "${tls_private_key.ec2_private_key.public_key_openssh}"
}

resource "aws_launch_configuration" "launch_config" {
  image_id        = var.ami
  security_groups = [aws_security_group.lc_sg.id]
  instance_type   = "t2.micro"
  key_name        = "react-instance-key"
  user_data       = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install git -y
                curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
                sudo apt install nodejs -y
                sudo apt install npm -y
                git clone https://github.com/mkcac/CAC.DevOps.Interview.git
                cd CAC.DevOps.Interview
                sudo npm install
                sudo npm run build
                sudo npm install -g serve
                sudo serve -s build &
                EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "webserver_asg" {
  name                 = aws_launch_configuration.launch_config.name
  launch_configuration = aws_launch_configuration.launch_config.name
  vpc_zone_identifier  = data.aws_subnet_ids.default.ids
  target_group_arns    = [aws_lb_target_group.alb_tg.arn]
  health_check_type    = "ELB"

  min_size = 1
  max_size = 1

  tag {
    key                 = "Name"
    value               = "terraform-assessment"
    propagate_at_launch = true
  }
}
