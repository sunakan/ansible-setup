terraform {
  required_providers {
    # registry
    # https://registry.terraform.io/providers/sacloud/sakuracloud/latest
    sakuracloud = {
      source  = "sacloud/sakuracloud"
      version = "2.25.4"
    }

    # HTTP Provider
    # https://registry.terraform.io/providers/hashicorp/http/latest/docs
    # HTTPリクエストを行い、結果を利用できるプロバイダー
    # 例: curl https://ipinfo.io/ip で自身の利用しているIPアドレスのみアクセス許可する
    http = {
      source  = "hashicorp/http"
      version = "3.4.4"
    }
  }
}
