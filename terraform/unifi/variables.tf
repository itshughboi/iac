variable "nodes" {
  type = map(object({
    mac = string
    ip  = string
  }))
}