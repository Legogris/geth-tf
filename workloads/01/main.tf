provider "aws" {
  version = "2.0.0"
  region  = "${var.aws_region}"

  assume_role {
    role_arn = "arn:aws:iam::731234585745:role/terraform-access"
  }
}

provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}


resource "aws_instance" "webapp" {
    # ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20180705 (ami-34c14f4a)
    #ami           = "ami-34c14f4a"
    # ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20180625 (ami-34c14f4a)
    ami           = "ami-35c14f4b"
    instance_type = "t3.nano"
    tags = {
        Name = "WebAppServer"
    }
}
resource "aws_eip" "webapp_ip" {
    vpc = true
}
resource "aws_eip_association" "webapp" {
    instance_id   = "${aws_instance.webapp.id}"
    allocation_id = "${aws_eip.webapp_ip.id}"
}
resource "cloudflare_record" "frontend_domain" {
    depends_on = ["aws_instance.webapp"]
    domain = "legogris.se"
    name   = "www3"
    value  = "${aws_eip.webapp_ip.public_ip}"
    type   = "A"
    ttl    = 3600
}
