terraform {
  required_version = ">= 0.11.2"

  backend "consul" {
    address         = "localhost:8500"
    path            = "tf/state/ec2-create"
    access_token    = "supersecure"
    lock            = true
  }
}
