variable str1 {}
variable str2 {}
variable access_key {}
variable secret_key {}
variable region {}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

output "access_key" {
  value = "${var.access_key}"
}

output "bucket_name" {
  value = "${var.str1}_${var.str2}"
}
