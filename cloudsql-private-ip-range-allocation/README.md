This module reserves a private IP range for Cloud SQL databases.

## Example Use of the Module 

```hcl

module "cloudsql_allocated_ip_range" {
    source          = "../terraform-modules/cloudsql-private-ip-range-allocation/"

    range_name                   = "cloud-sql-ip-range"
    description                  = "IP range for the Cloud SQL Instances"
    project_id                   = "my-project"
    network                      = "projects/my-network-project/global/networks/my-network"

    ip_address                   = "10.X.0.0"
    prefix_length                = 24


}