# create a random username for the virtual machine admin user
resource "random_string" "admin" {
  length  = 10
  special = false
}
