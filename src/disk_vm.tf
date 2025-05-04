# disk_vm.tf
resource "yandex_compute_disk" "extra_disk" {
  count = 3

  name     = "extra-disk-${count.index + 1}" # Имена: extra-disk-1, extra-disk-2, extra-disk-3
  size     = 1                               # Размер 1 ГБ
  type     = "network-hdd"                   # Тип диска
  zone     = var.default_zone                # Зона совпадает с зоной ВМ
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v1"
  zone        = var.default_zone

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os_image.id
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

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.extra_disk

    content {
      disk_id = secondary_disk.value.id
    }
  }

  metadata = local.full_metadata
}