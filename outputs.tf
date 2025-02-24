output "ec2-public-ip" {
  value = aws_instance.demo.public_ip

}