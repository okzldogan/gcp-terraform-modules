Grant IAM roles to users or groups or serviceaccounts on a GCP project.


module "project_iam_member_binding" {
    source          = "../../terraform-modules/project-iam-binding/"

    project_id                   = "my-project"

    bindings = {

        "roles/monitoring.viewer" = [
            "user:john-doe@my-domain.com",
            "group:my-group@my-domain.com",
            "serviceAccount:my-sa@my-domain.com",
        ]


        "roles/logging.viewer" = [
            "user:john-doe@my-domain.com",
            "group:my-group@my-domain.com",
            "serviceAccount:my-sa@my-domain.com",
        ]


    }


}