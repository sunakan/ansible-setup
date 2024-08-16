locals {
  # テザリングや自前のIPアドレス
  # パケットフィルタで利用
  my_ip = data.http.my_ip.response_body

  # 公開鍵のリスト
  # VMのSSH用の公開鍵登録で利用
  # 複数の公開鍵を登録している場合があるため、改行で結合されているため、split
  github_user_public_keys = split("\n", trimspace(data.http.public_keys.response_body))
}

data "http" "my_ip" {
  url = "https://ipinfo.io/ip"
}

data "http" "public_keys" {
  url = "https://github.com/${var.github_user}.keys"
}
