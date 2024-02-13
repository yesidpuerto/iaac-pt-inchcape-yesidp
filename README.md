# iaac-pt-inchcape-yesidp
Infrastructure as a code, in a separated repository.

#para ajustar el archivo iaac.tf y usarlo como una plantilla de terraform se debe tener en cuenta:
variable "profile" {
  description = "Nombre del perfil de AWS"
  default     = "ptyesidp"
}

variable "region" {
  description = "Región de AWS"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo de instancia de AWS"
  default     = "t2.micro"
  key_name    = "ptyesidp"#asociar par de claves para la conexion por ssh
}

variable "ssh_ip" {
  description = "Dirección IP desde la cual permitir SSH"
  default     = "181.51.52.210/32"
}
