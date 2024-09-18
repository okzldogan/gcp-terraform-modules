resource "google_filestore_instance" "instance" {

    name        = var.filestore_instance_name
    tier        = var.filestore_tier
    project     = var.project_id

    networks {
        network             = var.filestore_vpc_network
        modes               = ["MODE_IPV4"]
        # A /29 CIDR block that identifies the range of IP addresses reserved for this instance
        reserved_ip_range   = var.filestore_ip_range
        connect_mode        = "PRIVATE_SERVICE_ACCESS"
    }

    file_shares {

        name        = var.fileshare_name
        capacity_gb = var.filestore_capacity

        dynamic "nfs_export_options" {
            for_each = var.nfs_access_config

            content {
                # IP Ranges Allowed to Mount to the Filestore Instance
                ip_ranges   = lookup(nfs_export_options.value, "ip_ranges", [])
                # Possible Values are READ_ONLY and READ_WRITE
                access_mode = lookup(nfs_export_options.value, "access_mode", "READ_ONLY")
                # ROOT_SQUASH for not allowing root access
                squash_mode = lookup(nfs_export_options.value, "squash_mode", "ROOT_SQUASH")
                # Anonymous User ID Only when ROOT_SQUASH is set
                anon_uid    = lookup(nfs_export_options.value, "anon_uid", null)
                # Anonymous Group ID Only when ROOT_SQUASH is set
                anon_gid    = lookup(nfs_export_options.value, "anon_gid", null)
            }
        }


    }

    description = var.filestore_description
    labels      = var.filestore_labels
    location    = var.filestore_location

    kms_key_name= var.kms_key_name

}