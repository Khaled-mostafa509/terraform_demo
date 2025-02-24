variable "ami-data" {
  description = "value of ami"
  type        = string
  default     = "ami-04b4f1a9cf54c11d0"

}

variable "ec2-type" {
  description = "value of ec2-type"
  type        = string

}

variable "aws-vpc" {
    description = "cidr block for vpc"
  
}
variable "aws-subnet" {
    description = "cidr block for subnet"
  
}