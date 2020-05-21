variable "AWS_ACCESS_KEY" {}

variable "AWS_SECRET_KEY" {}

variable "AWS_REGION" {
  default = "us-west-1"
}


variable "AMIS" {
  default = {
    us-west-1      = "ami-0964ff6c2558ef45b" # private nginx 서버
    #us-west-1      = "ami-0f56279347d2fa43e" # ubuntu 1.8 서버
    eu-west-1      = "ami-0dad359ff462124ca"
    ap-northeast-2 = "ami-00edfb46b107f643c"
    us-east-1      = "ami-085925f297f89fce1"
  }
}

variable "INSTANCES_MICRO" {
  default = "t2.micro"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}

variable "PATH_TO_PUBLIC_KEY" {
    default = "~/.ssh/id_rsa.pub"
}

variable "PATH_TO_PRIVATE_KEY" {
    default = "~/.ssh/id_rsa"
}

variable "VERSION" {
    default = "0.1"
}

variable "WEB_SERVER_COUNT" {
    default = "0"
}

variable "PUBLIC_SUBNET_NUMBERS" {
    default = "2"
}

variable "AUTO_SCALE_MIN_SIZE" {
    default = "1"
}

variable "AUTO_SCALE_MAX_SIZE" {
    default = "2"
}

variable "ALB_ACCOUNT_ID" {
    default = "027434742980"
}
