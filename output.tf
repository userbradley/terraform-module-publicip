output "public-ip" {
  value = "${chomp(data.http.ip-echo.body)}/32"
}
