# 参考
# [GitHubからのSSH用の公開鍵を取得](https://docs.usacloud.jp/terraform/guides/public_key_from_github/)
# [サーバ: sakuracloud_server](https://docs.usacloud.jp/terraform/r/server/)
# [Terraform Tips 3選]()

############################################
# スイッチ(プライベートネットワーク)
# 時割: 11円
# 日割: 110円
############################################
resource "sakuracloud_switch" "sample" {
  name = "sample"
}

data "sakuracloud_archive" "ubuntu" {
  filter {
    names = ["Ubuntu Server 24.04 LTS 64bit (cloudimg)"]
  }
}

############################################
# Web
############################################
resource "sakuracloud_disk" "web_01" {
  name              = "web-01"
  source_archive_id = data.sakuracloud_archive.ubuntu.id
}
resource "sakuracloud_server" "web_01" {
  name   = "web-01"
  disks  = [sakuracloud_disk.web_01.id]
  core   = 1
  memory = 2
  network_interface {
    upstream         = "shared"
    packet_filter_id = sakuracloud_packet_filter.filter.id
  }
  network_interface {
    upstream = sakuracloud_switch.sample.id
  }
  user_data = templatefile("user_data.tftpl", {
    hostname : "web-01",
    ssh_authorized_keys : local.github_user_public_keys,
    cidr : "192.168.0.101/24",
  })
}

############################################
# DB
############################################
resource "sakuracloud_disk" "db_01" {
  name              = "db-01"
  source_archive_id = data.sakuracloud_archive.ubuntu.id
}
resource "sakuracloud_server" "db_01" {
  name   = "db-01"
  disks  = [sakuracloud_disk.db_01.id]
  core   = 1
  memory = 2
  network_interface {
    upstream         = "shared"
    packet_filter_id = sakuracloud_packet_filter.filter.id
  }
  network_interface {
    upstream = sakuracloud_switch.sample.id
  }
  user_data = templatefile("user_data.tftpl", {
    hostname : "db-01",
    ssh_authorized_keys : local.github_user_public_keys,
    cidr : "192.168.0.102/24",
  })
}

############################################
# Job Queue
############################################
resource "sakuracloud_disk" "job_queue_01" {
  name              = "job-queue-01"
  source_archive_id = data.sakuracloud_archive.ubuntu.id
}
resource "sakuracloud_server" "job_queue_01" {
  name   = "job-queue-01"
  disks  = [sakuracloud_disk.job_queue_01.id]
  core   = 1
  memory = 4
  network_interface {
    upstream         = "shared"
    packet_filter_id = sakuracloud_packet_filter.filter.id
  }
  network_interface {
    upstream = sakuracloud_switch.sample.id
  }
  user_data = templatefile("user_data.tftpl", {
    hostname : "job-queue-01",
    ssh_authorized_keys : local.github_user_public_keys,
    cidr : "192.168.0.103/24",
  })
}

############################################
# Job Worker
############################################
resource "sakuracloud_disk" "job_worker_01" {
  name              = "job-worker-01"
  source_archive_id = data.sakuracloud_archive.ubuntu.id
}
resource "sakuracloud_server" "job_worker_01" {
  name   = "job-worker-01"
  disks  = [sakuracloud_disk.job_worker_01.id]
  core   = 1
  memory = 2
  network_interface {
    upstream         = "shared"
    packet_filter_id = sakuracloud_packet_filter.filter.id
  }
  network_interface {
    upstream = sakuracloud_switch.sample.id
  }
  user_data = templatefile("user_data.tftpl", {
    hostname : "job-worker-01",
    ssh_authorized_keys : local.github_user_public_keys,
    cidr : "192.168.0.104/24",
  })
}
