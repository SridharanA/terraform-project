variable "access_key1" {
  type = string
  description = "This is an iam user access key"
  sensitive = true
}

variable "secret_key1" {
  type = string
  description = "This is an iam user secret access key"
  sensitive = true
}


variable "project_name" {
  type = string
  description = "This is name of this project"
}