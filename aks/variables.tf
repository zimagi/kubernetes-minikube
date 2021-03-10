variable "location" {
  description = "Default location"
  type        = string
  default     = "WEST US 2"
}

variable "namePrefix" {
  description = "Prefix of the provisioned objects"
  type        = string
  default     = "zimagi"
}

// variable "appId" {
//   description = "Azure Kubernetes Service Cluster service principal"
// }

// variable "password" {
//   description = "Azure Kubernetes Service Cluster password"
// }