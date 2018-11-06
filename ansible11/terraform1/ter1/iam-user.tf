variable str1 {}
variable str2 {}
variable access_key {}
variable secret_key {}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

output "access_key" {
  value = "${var.access_key}"
}

output "iam_user1" {
  value = "${var.str1}"
  value = "${var.str2}"
}
