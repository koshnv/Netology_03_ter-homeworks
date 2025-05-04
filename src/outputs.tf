# outputs.tf

output "vm_list" {
  description = "List of all VMs with name, id, and fqdn"
  value = flatten([
    # ВМ из yandex_compute_instance.web (count)
    [
      for vm in yandex_compute_instance.web : {
        name = vm.name
        id   = vm.id
        fqdn = "${replace(vm.name, "-", "")}${var.default_zone}.internal"
      }
    ],
    # ВМ из yandex_compute_instance.db (for_each)
    [
      for vm in values(yandex_compute_instance.db) : {
        name = vm.name
        id   = vm.id
        fqdn = "${replace(vm.name, "-", "")}${var.default_zone}.internal"
      }
    ],
    # ВМ из yandex_compute_instance.storage (одиночная)
    [
      {
        name = yandex_compute_instance.storage.name
        id   = yandex_compute_instance.storage.id
        fqdn = "${yandex_compute_instance.storage.name}${var.default_zone}.internal"
      }
    ]
  ])
}