variable "hcloud_token" {
  sensitive = true
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_server" "vault" {
    name        = "vault-1"
    image       = "debian-11"
    server_type = "cx11"
    public_net {
        ipv4_enabled = true
        ipv6_enabled = true
    }
}