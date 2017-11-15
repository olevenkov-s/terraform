# Configure the Terraform backend
terraform {
  backend "s3" {
    # Be sure to change this bucket name and region to match an S3 Bucket you have already created!
    bucket = "terraform-slalom"
    region = "us-east-2"
    key    = "terraform.tfstate"
  }
}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "count" {
    default = "2"
}
variable "aws_region" {
    default = "us-east-2"
}

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
    
}
resource "aws_instance" "example" {
    count = "${var.count}"
    ami = "ami-c5062ba0"
    instance_type = "t2.nano"
    key_name = "oleg_levenkov_slalom"
    subnet_id = "subnet-cf73fcb4"
    vpc_security_group_ids = ["sg-888d76e0"]
    tags {
        Name = "terraform-instence"
        Owner = "Oleg Levenkov"
    }
}

resource "aws_eip" "example" {
    count = "${var.count}"
    instance = "${element(aws_instance.example.*.id, count.index)}"    
} 

#output "public_ip" {
#    value = "${join(", ", aws_instance.example.*.public_ip)}"
#}
#output "private_ip" {
#    value = "${join(", ", aws_instance.example.*.private_ip)}"
#}
#output "public_dns" {
#    value = "${join(", ", aws_instance.example.*.public_dns)}"
#}
#output "private_dns" {
#    value = "${join(", ", aws_instance.example.*.private_dns)}"
#}
output "eip_public_ip" {
    value = "${join(", ", aws_eip.example.*.public_ip)}"
}
