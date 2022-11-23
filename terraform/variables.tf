variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "rgName" {
  default     = "automategis_terraform"
  description = "resource group name"
}

variable "vnetName" {
  default     = "vnet1"
  description = "vnet name"
}

variable "vnetAddressSpace" {
  default     = "10.0.0.0/16"
  description = "vnet address range"
}

variable "workloadSubnetName" {
  default     = "workloadsubnet"
  description = "the name of the workload subnet"
}
variable "workloadSubnetAddressPrefix" {
  default     = "10.0.1.0/24"
  description = "subnet address worload prefix"
}

variable "nsgName" {
  default     = "nsg1"
  description = "nsg name"
}
####################  vm general ####################
variable "vmSize" {
  default     = "Standard_DS2_v2"
  description = "vm size"
}
variable "pipAllocation" {
  default     = "Static"
  description = "public ip allocation method"
}
variable "pipSku" {
  default     = "Standard"
  description = "public ip sku"
}
variable "lbPipDn" {
  default     = "automateterrafrom"
  description = "FQDN for the public ip of the webserver"
}
#################### /vm general ####################

#################### vm web ####################
variable "webPrefix" {
  default     = "web"
  description = "a prefix to be used in naming every resource related to web vms."
}

#################### / vm web ####################

#################### vm gis ####################
variable "gisPrefix" {
  default     = "gis"
  description = "a prefix to be used in naming every resource related to gis vms."
}
#################### / vm gis ####################

####################  vm db ####################
variable "dbPrefix" {
  default     = "db"
  description = "a prefix to be used in naming every resource related to db vms."
}
#################### / vm db ####################