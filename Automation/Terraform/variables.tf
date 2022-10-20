variable "rg_01_name" {
  type = string
  default = "rg-myproject-01"
}
variable "rg_01_location" {
  type = string
  default = "EastUS"
}
variable "rg_02_name" {
  type = string
  default = "rg-myproject-02"
}
variable "rg_02_location" {
  type = string
  default = "EastUS"
}
variable "vnet_01_name" {
  type = string
  default = "vnet-myproject-eus-01"
}
variable "vnet_01_address_space" {
  type = list(string)
  default = [ "10.0.0.0/16" ]
}
variable "subnet1_name" {
  type = string
  default = "subnet1"
}
variable "subnet1_address_prefix" {
  type = string
  default = "10.0.1.0/24"
}
variable "subnet2_name" {
  type = string
  default = "subnet2"
}
variable "subnet2_address_prefix" {
  type = string
  default = "10.0.2.0/24"
}
variable "tag_env_name" {
  type = string
  default = "Development"
}