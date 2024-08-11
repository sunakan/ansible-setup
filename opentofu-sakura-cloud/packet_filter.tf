resource "sakuracloud_packet_filter" "filter" {
  name = "テザリングから"
  expression {
    allow          = true
    description    = "テザリング"
    protocol       = "ip"
    source_network = local.my_ip
  }
  expression {
    allow            = true
    description      = "一般通信用、エフェメラルポートの許可"
    destination_port = "32768-61000"
    protocol         = "tcp"
    source_network   = "0.0.0.0/0"
  }
  expression {
    allow            = true
    description      = "一般通信用、エフェメラルポートの許可"
    destination_port = "32768-61000"
    protocol         = "udp"
    source_network   = "0.0.0.0/0"
  }
  expression {
    allow            = true
    description      = "DHCP通信用"
    destination_port = "67-68"
    protocol         = "udp"
    source_network   = "0.0.0.0/0"
  }
  expression {
    allow          = false
    protocol       = "ip"
    source_network = "0.0.0.0/0"
  }
}
