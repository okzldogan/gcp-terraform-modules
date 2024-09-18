Creates firewall rules in a GCP project for a network.

Example usage below:


```hcl

##################################################################
### Create Firewall Rule for VM to Receive SSH IAP Connection ####
##################################################################

module "firewall_rules" {
  source       = "../../../terraform-modules/fw-rules/"

  project_id   = "my-project"
  network_name = "my-network"

  rules = [
    {
    name                    = "ssh-iap-access-to-a-vm"
    description             = "Firewall rule to allow SSH ingress via IAP"
    direction               = "INGRESS"
    priority                = 1000
    ranges                  = ["35.235.240.0/20"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = ["my-vm-tag"]
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = ["22"]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  },
#######################################################################
###  Firewall Rule for Bastion Hosts to Access GKE Master IP Range ####
#######################################################################
  {
    name                    = "allow-egress-from-vm-to-an-ip-range"
    description             = "Firewall rule to allow Egress from a VM to an IP Range."
    direction               = "EGRESS"
    priority                = 1000
    ranges                  = [
      "10.X.X.X/8",
      "172.X.X.X/16",
      "192.X.X.X/24"
      ]
    source_tags             = null
    source_service_accounts = null
    target_tags             = ["my-vm-tag"]
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = ["0-65000"]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  },


```
