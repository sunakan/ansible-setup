# 参考
# [GitHubからのSSH用の公開鍵を取得](https://docs.usacloud.jp/terraform/guides/public_key_from_github/)
# [サーバ: sakuracloud_server](https://docs.usacloud.jp/terraform/r/server/)

data "sakuracloud_archive" "ubuntu" {
  filter {
    names = ["Ubuntu Server 24.04 LTS 64bit (cloudimg)"]
  }
}

############################################
# All-in-One
############################################
resource "sakuracloud_disk" "aio" {
  name              = "aio"
  source_archive_id = data.sakuracloud_archive.ubuntu.id
}
resource "sakuracloud_server" "aio" {
  name   = "aio"
  disks  = [sakuracloud_disk.aio.id]
  core   = 2
  memory = 2
  network_interface {
    upstream         = "shared"
    packet_filter_id = sakuracloud_packet_filter.filter.id
  }
    user_data = templatefile("user_data.tftpl", {
    hostname: "aio",
    ssh_authorized_keys: local.github_user_public_keys,
  })
}
