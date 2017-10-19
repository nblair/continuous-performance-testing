output "node_public_dns" {
  value = ["${aws_instance.my-host.public_ip}"]
}

output "ssh_key" {
  value = "${tls_private_key.ssh_key.private_key_pem}"
}
