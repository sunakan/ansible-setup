terraform {
  required_providers {
    # registry
    # https://registry.terraform.io/providers/sacloud/sakuracloud/latest
    sakuracloud = {
      source  = "sacloud/sakuracloud"
      version = "2.25.4"
    }
  }
}
