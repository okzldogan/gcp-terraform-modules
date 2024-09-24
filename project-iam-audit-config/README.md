This module enables audit logs for a project.

Example Use of the Module:

```hcl


module "enable_audit_logs" {
    source          = "../terraform-modules/project-iam-audit-config/"

    project_id                 = "my-project"

    project_audit_logs_config = [

        {
            service_name            = "cloudsql.googleapis.com",
            log_types               = [
                "DATA_READ",
                "DATA_WRITE"
            ]
        },
        {
            service_name            = "my-api.googleapis.com",
            log_types               = [
                "ADMIN_READ",
                "DATA_READ",
                "DATA_WRITE"
            ]
        },
    ]



}

```