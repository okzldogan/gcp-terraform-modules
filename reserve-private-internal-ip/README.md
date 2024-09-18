This module reserves a private IP address for a VM.

Project ID refers to the project in which the IP adress will be created.

Network field requires the full qualified name as indicated in the below example.

Example Use of the Module:

```hcl

module "my_vm_static_internal_ip" {
    source          = "../../../terraform-modules/reserve-private-internal-ip/"

    project_id                  = "<project-id>"
    name                        = "my-vm-static-ip"
    internal_ip_address         = "<ip-address>             # It should be within the IP range of the indicated subnet
    description                 = "<description>"
    subnet                      = "projects/<subnet-project-id>/regions/<region>/subnetworks/<subnet-name>"
    region                      = "<region>"

}

```