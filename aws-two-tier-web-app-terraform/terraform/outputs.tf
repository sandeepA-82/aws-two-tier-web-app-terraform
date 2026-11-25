output "web_server_public_ip" {
  description = "Public IPv4 address of the EC2 web server."
  value       = aws_instance.web.public_ip
}

output "web_application_url" {
  description = "URL for the initial EC2 HTTP test page."
  value       = "http://${aws_instance.web.public_ip}"
}

output "rds_endpoint" {
  description = "Private RDS endpoint. It is not publicly accessible."
  value       = aws_db_instance.main.endpoint
}

output "database_name" {
  description = "Initial database name."
  value       = aws_db_instance.main.db_name
}
