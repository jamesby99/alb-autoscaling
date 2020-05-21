#  output "public_ip_of_web_server" {
#      value = {
#          for instance in aws_instance.web-server:
#          instance.id => instance.public_ip...
#      }
#  }

# output "web_server_private_ip" {
#     value = {
#         for instance in aws_instance.web-server:
#         instance.availability_zone => instance.private_ip...
#     }
# }

# output "web_server_public_ip" {
#     value = {
#         for instance in aws_instance.web-server:
#         instance.availability_zone => instance.public_ip...
#     }
# }

output "ELB" {
	value = aws_alb.user11-alb.dns_name
}
