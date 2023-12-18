variable "vpc_id" {
    type = string
    description = "(optional) describe your variable"
}



variable "ami_id" {
    type = string
    description = "ami id"
    default = "ami-0230bd60aa48260c6"
}

variable "public_sn1_id" {
    type = string
    description = "public subnet ids"
}

variable "public_sn2_id" {
    type = string
    description = "public subnet ids"
}

variable "tags" {
    type = map(string)
    description = "(optional) describe your variable"
}

variable "key_pair_name" {
  type        = string
  description = "keypair to utilize"
}