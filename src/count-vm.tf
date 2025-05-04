# count-vm.tf
resource "yandex_compute_instance" "web" {
  count = 2

  name        = "web-${count.index + 1}" # Имена: web-1, web-2
  platform_id = "standard-v1"
  zone        = var.default_zone

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os_image.id # Использую динамический image_idd
    }
  }
  
  scheduling_policy {
    preemptible = true  # Использую preemptible
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  
  depends_on = [yandex_compute_instance.db] # Зависимость обеспечивает создание ВМ web после ВМ db
  
  metadata = local.full_metadata
}