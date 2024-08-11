data "http" "my_ip" {
  url = "https://ipinfo.io/ip"
}

locals {
  my_ip = data.http.my_ip.response_body
}
