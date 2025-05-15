
variable "sg_config" {
  description = "The configuration for the security group"
  type = object({
    name          = string
    description   = string
    environment   = string
    vpc_id        = optional(string)
    ingress_ports = optional(list(number))
    ingress_cidrs = optional(list(string))
    tags          = optional(map(string))
  })

}






