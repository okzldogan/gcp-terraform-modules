This module creates a standard dns entry.

## Example Use of the Module 

```hcl

module "standard_dns_entry" {
    source          = "../../../terraform-modules/dns-entry/standard-entry/"                          

    project_id                  = "<project-id>"
    zone_name                   = "<zone-name>"
    domain_name                 = "example.local."


    recordsets = [
        {
            name    = "my-entry"
            type    = "A"
            ttl     = 300
            records = [
                "ip-address-1",
            ]
        },
        {
            name    = "new-entry"       
            type    = "A"
            ttl     = 300
            records = [
                "ip-address-2"
            ]
        }
    ]

        
}

```
