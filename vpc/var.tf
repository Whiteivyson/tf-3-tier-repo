variable "vpc_cidr" {
  type        = string
  description = "vpc cidr block"
  default     = "10.0.0.0/16"
}

variable "public_sn1_cidr" {
  type        = string
  description = "(optional) describe your variable"
  default     = "10.0.1.0/24"
}

variable "public_sn2_cidr" {
  type        = string
  description = "(optional) describe your variable"
  default     = "10.0.2.0/24"
}

variable "private_sn1_cidr" {
  type        = string
  description = "(optional) describe your variable"
  default     = "10.0.3.0/24"
}

variable "private_sn2_cidr" {
  type        = string
  description = "(optional) describe your variable"
  default     = "10.0.4.0/24"
}


variable "tags" {
    type = map(string)
    description = "(optional) describe your variable"
}