data "external" "git-branch" {
  program = ["/bin/bash", "./src/main/setup/git-branch.sh"]
}

provider "aws" {
  region = "${var.aws_region}"
  assume_role = {
    role_arn = "${var.assume_role_arn}"
  }
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
}

### Network

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Application = "my-application"
    Branch = "${data.external.git-branch.result.branch}"
    BuildKey = "${var.build_key}"
    runner = "${var.runner}"
    environment = "stress-test-temporary-safe-to-delete"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Application = "my-application"
    Branch = "${data.external.git-branch.result.branch}"
    BuildKey = "${var.build_key}"
    runner = "${var.runner}"
    environment = "stress-test-temporary-safe-to-delete"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags {
    Application = "my-application"
    Branch = "${data.external.git-branch.result.branch}"
    BuildKey = "${var.build_key}"
    runner = "${var.runner}"
    environment = "stress-test-temporary-safe-to-delete"
  }
}

resource "aws_security_group" "ec2" {
  name_prefix = "my-application-ec2-security-group"
  description = "My Application EC2 Security Group"
  vpc_id      = "${aws_vpc.default.id}"

  ## externally accessible ports
  # app
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # 8099/8044 needed for JMX
  ingress {
    from_port   = 8099
    to_port     = 8099
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8044
    to_port     = 8044
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # allow node to make outbound connections
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Application = "my-application"
    Branch = "${data.external.git-branch.result.branch}"
    BuildKey = "${var.build_key}"
    runner = "${var.runner}"
    environment = "stress-test-temporary-safe-to-delete"
  }
}

resource "aws_key_pair" "auth" {
  key_name_prefix = "my-application-test"
  public_key = "${tls_private_key.ssh_key.public_key_openssh}"
}

resource "aws_instance" "my-host" {
  #iam_instance_profile = "${aws_iam_instance_profile.ec2_instance_profile.id}"

  connection {
    user = "ec2-user"
    private_key = "${tls_private_key.ssh_key.private_key_pem}"
  }

  instance_type = "${var.instance_type}"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  key_name = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.ec2.id}"]
  subnet_id = "${aws_subnet.default.id}"
  private_ip = "10.0.1.10"
  monitoring  = true

  ebs_block_device {
    device_name = "/dev/xvdh"
    volume_size = "${var.data_volume_size}"
    volume_type = "${var.data_volume_type}"
    iops = "${var.data_volume_iops}"
  }
  provisioner "file" {
    source      = "src/main/setup"
    destination = "."
  }

  provisioner "file" {
    source = "target/dependency/"
    destination = "."
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y -q jq",
      <<EOF
      jq -n \
        --arg ip "${self.public_ip}" \
        --arg branch "${data.external.git-branch.result.branch}" \
        --arg ms "${var.java_min_heap}" \
        --arg mx "${var.java_max_heap}" \
        '{"ip":$ip,"branch":$branch,"ms":$ms,"mx":$mx}' \
        > ./setup/bootstrap.json
      EOF
      ,
      "chmod a+x ./setup/bootstrap.d/*.sh",
      "sudo bash ./setup/bootstrap.sh"
    ]
  }

  tags {
    Name = "my-application-host"
    Application = "my-application"
    Branch = "${data.external.git-branch.result.branch}"
    BuildKey = "${var.build_key}"
    runner = "${var.runner}"
    environment = "stress-test-temporary-safe-to-delete"
  }
}