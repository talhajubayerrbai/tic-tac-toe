output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.tic_tac_toe.public_ip
}

output "public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.tic_tac_toe.public_dns
}

output "url" {
  description = "Game URL"
  value       = "http://${aws_instance.tic_tac_toe.public_ip}:3000"
}
