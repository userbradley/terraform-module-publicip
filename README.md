# Terraform Module for your public IP

## What is this

This is made to be used in terraform as a module loaded in, and then refrenced in firewall rules, or where ever you need your current public IP address

I've made this to prevent having to set your env var each time you run a terraform apply on your laptop and move around

## Using the module:

Create a file called `modules.tf`

In that file paste the below:

```terraform
module "ip" {
  source = "github.com/userbradley/terraform-module-publicip"
}
```

### GCP:

Example for SSH:
```terraform
resource "google_compute_firewall" "ssh" {
  name          = "${var.me}-ssh-inbound"
  network       = google_compute_network.vpc.id
  source_ranges = ["${module.ip.public-ip}"]
  target_tags   = ["ssh"]
  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
```
### AWS:

Example for All ports
```terraform
resource "aws_security_group" "home" {
  name = "Access from Home"
  description = "Allows access from my Home ip"
  vpc_id = data.terraform_remote_state.setup.outputs.vpc-id
  ingress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["${module.ip.public-ip}"]
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS009
  }
  tags = {
    Name = "Access from home"
  }
}
```

## Contributing

You're welcome to fork this, and make changes, but there's not much to change.

