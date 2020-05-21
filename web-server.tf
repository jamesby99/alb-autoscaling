resource "aws_instance" "web-server" {

    count                   = var.WEB_SERVER_COUNT
    ami                     = lookup(var.AMIS, var.AWS_REGION)
    instance_type           = var.INSTANCES_MICRO
    key_name                = aws_key_pair.public_key.key_name
    #서브넷
    subnet_id               = aws_subnet.user11-public[count.index%var.PUBLIC_SUBNET_NUMBERS].id
    #시큐리티그룹
    vpc_security_group_ids  = [aws_security_group.allow-http.id, aws_security_group.allow-ssh.id] # the security group

    connection {
        host        = self.public_ip
        user        = var.INSTANCE_USERNAME
        private_key = file(var.PATH_TO_PRIVATE_KEY)
    }

    provisioner "file" {
         # nginx-install.sh , index.html, iu.gif 복사
         source      = "copy-files/"
         destination = "/tmp/"
    }

    provisioner "remote-exec" {
         inline = [
             "chmod +x /tmp/nginx-install.sh",
             "sudo /tmp/nginx-install.sh"
         ]
    }


    tags = {
        Name = format("user11-web-%d-v:%s", count.index+1, var.VERSION)
    }

}

