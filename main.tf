variable "uri" {}

variable "body_must_include" {
  default = ""
}

variable "code_must_equal" {
  default = "200"
}

variable "max_tries" {
  default = "60"
}

variable "interval" {
  default = "1"
}

data "external" "http" {
  program = ["ruby", "${path.module}/http.rb"]

  query = {
    uri               = "${var.uri}"
    body_must_include = "${var.body_must_include}"
    code_must_equal   = "${var.code_must_equal}"
    max_tries         = "${var.max_tries}"
    interval          = "${var.interval}"
  }
}

output "result" {
  value = "${data.external.http.result}"
}
