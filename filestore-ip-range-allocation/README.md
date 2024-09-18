This module reserves an IP range for a Filestore instance.

Example Use of the Module 

```hcl

module "filestore_allocated_ip_range" {
    source          = "../../../terraform-modules/filestore-ip-range-allocation/"

    range_name                   = "filestore-ip-range-${var.env}"
    description                  = "IP range for the Filestore Instance in ${var.env} environment"
    project_id                   = "my-network-project"
    network                      = "projects/y-network-project/global/networks/my-network"

    ip_address                   = "my-ip-range"
    prefix_length                = 24


}

```