variable "num_instances" {
  type = number
}

variable "name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_id" {
  type    = string
  default = "ami-0f511ead81ccde020"
}

variable "tags" {
  type    = map(any)
  default = {}
}
