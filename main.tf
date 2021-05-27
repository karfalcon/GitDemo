module "react_app" {
  source      = "./modules/webapp"
  server_port = 5000
  alb_port    = 80
  ami         = "ami-040ea95249cccbe1c"
}
