###cloud vars
#variable "token" {
#  type        = string
#  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
#}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}


###ssh vars
variable "ssh-keys_pub" {
  type        = string
  default     = null
  description = "Public SSH key for VM access"
}

###metadata for VMs
variable "metadata" {
  type = map(string)
  default = {
    serial-port-enable = "1"
    ssh-keys           = null
  }
  description = "Metadata for VMs"
}

# Переменная для ВМ баз данных
variable "vm_os_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Image family for the VM"
}

# Переменная для for_each
variable "each_vm" {
  type = list(object({
    vm_name       = string
    cpu           = number
    ram           = number
    disk_volume   = number
    platform_id   = string  # Добавляю платформу
    preemptible   = bool    # Добавляю параметр preemptible
    core_fraction = number  # Добавляю core_fraction для экономии
    disk_type     = string  # Добавляю тип диска
    nat           = bool    # Добавляю Nat
  }))
  default = [
    { vm_name = "main", cpu = 2, ram = 2, disk_volume = 10, platform_id = "standard-v3", preemptible = true, nat = true, core_fraction = 20, disk_type = "network-hdd" },
    { vm_name = "replica", cpu = 2, ram = 2, disk_volume = 10, platform_id = "standard-v3", preemptible = true, nat = true, core_fraction = 20, disk_type = "network-hdd" }
  ]
  description = "Configuration for database VMs"
}