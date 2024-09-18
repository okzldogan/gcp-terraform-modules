This module reserves a public IP address for the global external loadbalancer.

Project ID refers to the project in which the IP adress will be created.

Network field requires the full qualified name as indicated in the below example.

Example Use of the Module:

```hcl

module "global_external_lb_ip" {
    source          = "../../../terraform-modules/reserve-global-lb-public-ip/"

    name                         = "public-ip-test"
    description                  = "Public IP for Global LB"
    project_id                   = "test-project"
    network                      = "projects/<project-name>/global/networks/<vpc-name>"


}

```