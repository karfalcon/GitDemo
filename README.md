# Solution

1. Terraform module 'webapp' creates ec2 instances (auto scaling configured) with the react app installed and a load balancer in front of it with necessary security and networking configurations.
2. Default vpc and subnets has been used.
3. To run

  ```bash
  $ terraform init
  $ terraform apply
  ```

4. To get the alb url for the react app:

  $ terraform output web_app_url

  and then access the url in the browser to view the application
  
