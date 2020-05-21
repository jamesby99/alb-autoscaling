resource "aws_launch_configuration" "user11-launchconfig" {
  name_prefix          = "user11-launchconfig"
  image_id             = lookup(var.AMIS, var.AWS_REGION)
  instance_type        = "t2.micro"
  key_name             = aws_key_pair.public_key.key_name
  security_groups      = [aws_security_group.allow-http.id, aws_security_group.allow-ssh.id]
  #user_data            = "#!/bin/bash\napt-get update\napt-get -y install nginx\nMYIP=`ifconfig | grep 'addr:10' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'this is: '$MYIP > /usr/share/nginx/html/index.html"
  lifecycle              { create_before_destroy = true }
}

resource "aws_autoscaling_group" "webserver-autoscaling" {
  name                 = "webserver-autoscaling"
  vpc_zone_identifier  = [aws_subnet.user11-public[0].id, aws_subnet.user11-public[1].id]
  launch_configuration = aws_launch_configuration.user11-launchconfig.id
  min_size             = var.AUTO_SCALE_MIN_SIZE
  max_size             = var.AUTO_SCALE_MAX_SIZE
  health_check_grace_period = 300
  health_check_type = "EC2"
  #health_check_type = "ELB" 
  force_delete = true

  tag {
      key = "Name"
      value = "user11-web-autoscaling"
      propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "web_tracking_policy" {
  name                      = "tracking-policy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.webserver-autoscaling.name
  estimated_instance_warmup = 200

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
      #predefined_metric_type = "ALBRequestCountPerTarget"
    }
    target_value = "10" #CPU 10%
    #target_value = "1" #Request 1
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  alb_target_group_arn   = aws_alb_target_group.targets.arn
  autoscaling_group_name = aws_autoscaling_group.webserver-autoscaling.id
}

