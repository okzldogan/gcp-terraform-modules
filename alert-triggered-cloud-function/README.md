This module creates the following components:

1. PubSub Topic which will be used to contain JSON format alerts and to push them to a Cloud Function.
2. PubSub type Alert Notification channel which will receive alerts.
3. Cloud Function which will read the PubSub message and trigger a GitHub workflow.


######################################
##### Example Use of the Module ######
######################################

###################################################################
### PubSub Topic for Alerting via PubSub to a Cloud Function ######
###################################################################

resource "google_pubsub_topic" "my_alert_topic" {

    project = "my-project"
    name    = "my-alert-topic"

    labels  = {
        usage   = "alerting"
        target  = "cloud_function"
    }

}

# Create a PubSub notification channel to trigger a Cloud Function

resource "google_monitoring_notification_channel" my_pubsub_notification_channel" {
    
    display_name    = "PubSub notification channel to trigger a Cloud Function"
    description     = "Notification Channel for sending alerts via PubSub to a Cloud Function."
    type            = "pubsub"

    project         = "my-project"

    enabled         = true

    labels = {
        topic    = google_pubsub_topic.my_alert_topic.id
    }
}

# Get the source code from the local directory and create a zip file

data "archive_file" "source_code" {

    type        = "zip"
    output_path = "../Cloud-Functions/my-source-file-directory/source-file.zip"
    source_dir  = "../Cloud-Functions/my-source-file-directory/source-code"
}


######################################################
### Create Function to Read PubSub Message   #########
######################################################

module "pubsub_reader_cloud_function" {
    source          = "../terraform-modules/alert-triggered-cloud-function/"

    project_id                      = "my-project"
    bucket_location                 = "my-region"

    cloudfunction_labels            = {
        environment = "my-environment"
        function    = "my_function"
    }

    environment_variables           = {
        LOG_EXECUTION_ID = true
        REPO_NAME        = "my-repo-name"
        WORKFLOW_NAME    = "my-workflow-file-name.yaml"
    }

    source_file_name                = "my-source-file.zip"
    source_file_path                = data.archive_file.source_code.output_path

    pubsub_topic_name               = "my-pubsub-topic-name"

    function_name                   = "trigger-github-workflow"
    function_location               = "my-region"
    function_description            = "Triggers a github action."
    function_runtime                = "python312"
    function_entry_point            = "trigger_github_action"

    function_memory                 = "256M"

    retry_policy                    = "RETRY_POLICY_DO_NOT_RETRY"

    service_account_email           = "my-cloudfunction-service-account-email"
    
}