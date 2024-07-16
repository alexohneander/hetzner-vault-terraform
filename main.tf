variable "hcloud_token" {
  sensitive = true
  type = string
}

variable "vm_admin_username" {
  type = string
  default = "root"
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
    ssh_keys = ["awellnit@MB-FVFHN41RQ05N", "alex@thinkpad"]
}

resource "ansible_host" "inventory" {
  name   = hcloud_server.vault.ipv4_address
  groups = ["vault"]
  variables = {
    ansible_user                 = var.vm_admin_username
    # ansible_ssh_private_key_file = ".ssh/nomad_key"
    ansible_python_interpreter   = "/usr/bin/python3"
  }
  depends_on = [hcloud_server.vault]
}

resource "ansible_playbook" "playbook" {
  playbook   = "playbook.yml"
  name       = hcloud_server.vault.ipv4_address
  groups = ansible_host.inventory.groups
  replayable = true

  extra_vars = {
    var_a = "Some variable"
    var_b = "Another variable"
  }
  depends_on = [ansible_playbook.playbook]
}