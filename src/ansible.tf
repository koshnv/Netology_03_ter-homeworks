# ansible.tf

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tmpl", {
    webservers = yandex_compute_instance.web
    databases  = values(yandex_compute_instance.db)
    storage    = yandex_compute_instance.storage
    zone       = var.default_zone
  })
  filename = "${path.module}/ansible_inventory.ini"
}