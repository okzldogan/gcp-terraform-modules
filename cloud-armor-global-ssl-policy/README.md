This module creates a "GLOBAL" SSL policy. ( not regional)

## Google Documentation on SSL & TLS 

https://cloud.google.com/load-balancing/docs/ssl-policies-concepts#profilefeaturesupport

## Predefined SSL policy profiles/types

COMPATIBLE. Allows the broadest set of clients, including clients that support only out-of-date SSL features, to negotiate SSL with the load balancer.

MODERN. Supports a wide set of SSL features, allowing modern clients to negotiate SSL.

RESTRICTED. Supports a reduced set of SSL features, intended to meet stricter compliance requirements.

On the other hand "CUSTOM" profile/type lets you select SSL features individually.

## Example Use of the Module

```hcl

 module "ssl_policy_tls12_compatible" {
    source          = "../../../terraform-modules/cloud-armor-global-ssl-policy/"   ### Verify the module's path

    project_id              = "<project-id>"
    ssl_policy_name         = "ssl-policy-tls-12-compatible"
    ssl_policy_description  = "Global Compatible SSL policy with version 1.2"

    min_tls_version         = "TLS_1_2"
    ssl_policy_type         = "COMPATIBLE"


}

```