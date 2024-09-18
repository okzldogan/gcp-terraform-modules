This module creates folder(s) with folder iam bindings.


Example Use of the Module 

```hcl
 module "folders" {
  source  = "../terraform-modules/gcp-folder-management/"        

  folders = [
    {
        display_name    = "my-folder-1"
        parent          = "my-org-id"

        bindings    = {
            "roles/resourcemanager.folderViewer" = [
              "group:my-group@my-domain.com"
            ] 
        }

    },
    {
      display_name    = "my-folder-2"
      parent          = "my-org-id"

      bindings      = {
        "roles/resourcemanager.folderAdmin" = [
          "user:my-user@my-domain.com",
        ]
      }
    }

  ]
  

}

```