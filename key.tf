resource "aws_key_pair" "public_key" {
  key_name   = "public_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}
