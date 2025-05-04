# for_each-vm.tf

resource "yandex_compute_instance" "db" {
  for_each = { for idx, vm in var.each_vm : vm.vm_name => vm }

  name        = each.value.vm_name
  platform_id = each.value.platform_id  # Использую platform_id из переменной
  zone        = var.default_zone

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction  # Использую core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os_image.id
      size     = each.value.disk_volume
      type     = each.value.disk_type  # Использую disk_type
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = each.value.nat  # Использую nat из переменной
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  scheduling_policy {
    preemptible = each.value.preemptible  # Использую preemptible
  }

  metadata = local.full_metadata
}