This module creates a filestore instance ( GCP managed NFS)


# Example Use of the Module

```hcl

module "filestore_instance" {
    source          = "../terraform-modules/filestore-instance/"

    filestore_instance_name     = "k8s-volume"
    filestore_tier              = "BASIC_HDD"
    project_id                  = "my-filestore-project"

    filestore_location          = "my-zone"
    filestore_description       = "insert description here"

    filestore_vpc_network       = "projects/my-network-project/global/networks/my-network"

    filestore_ip_range          = "my-filestore-ip-range"
     
    fileshare_name              = "my_volume"
    filestore_capacity          = 1024

    nfs_access_config = {
        ## NFS Config for NFS Bastion Host ( READ_WRITE + ROOT Access)
        "NFS-Bastion" = {
            ip_ranges = [
                "my-ip/32"
            ]
            access_mode = "READ_WRITE"
            squash_mode = "NO_ROOT_SQUASH"
            anon_uid    = 0
            anon_gid    = 0
        }
        ## NFS Config for GKE Cluster ( READ_WRITE + NON-ROOT Access)
        "GKE-Cluster" = {
            ip_ranges = [
                "insert-ip/insert-subnet",
                "other-ip/indicate-subnet-prefix",
            ]
            access_mode = "READ_WRITE"
            squash_mode = "ROOT_SQUASH"

            anon_uid    = 101   # Indicate the UID of the user to be used for anonymous access
            anon_gid    = 102   # Indicate the GID of the user to be used for anonymous access
            
        }
    }

    filestore_labels            = {
        environment = "my_environment"
        usage       = "gke"
    }


}

```