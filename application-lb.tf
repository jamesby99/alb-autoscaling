resource "aws_alb" "user11-alb" {

  name = "user11-alb"
  internal = false
  subnets = [aws_subnet.user11-public[0].id, aws_subnet.user11-public[1].id]
  security_groups = [aws_security_group.allow-http.id]
  
  # access_logs {
  #   bucket = aws_s3_bucket.alb.id
  #   prefix = "frontend-alb"
  #   enabled = true
  # }

  lifecycle { 
    create_before_destroy = true 
  }

  tags = {
    Name = "user11-alb"
  }
  
}

resource "aws_alb_target_group" "targets" {
    name = "target-group"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.user11-vpc.id
    
    health_check {
        interval = 30
        path = "/"
        healthy_threshold = 3
        unhealthy_threshold = 3
    }   

    tags = { 
        Name = "user11-target-group" 
    }
}

# autoscaling이 아닌 instance 대상일 경우
# resource "aws_alb_target_group_attachment" "attach-targets" {
#     # count = var.WEB_SERVER_COUNT
#     target_group_arn = aws_alb_target_group.targets.arn
#     # target_id = aws_instance.web-server[0].id
#     target_id = aws_autoscaling_group.webserver-autoscaling.id
#     port = 80
# }

resource "aws_alb_listener" "http" {
    load_balancer_arn = aws_alb.user11-alb.arn
    port = "80"
    protocol = "HTTP"
    default_action {
        target_group_arn = aws_alb_target_group.targets.arn
        type = "forward"
    }
}


