resource "google_project" "project" {
  name            = "${var.google_project}"
  project_id      = "${var.google_project}"
  billing_account = "${var.google_billing_account}"
  org_id          = "${var.google_org_id}"
}

resource "google_project_iam_member" "project" {
  project = "${google_project.project.project_id}"
  role    = "roles/owner"
  member  = "serviceAccount:terraform@kaiko-terraform-admin.iam.gserviceaccount.com"
}

resource "google_project_services" "project" {
  project = "${google_project.project.project_id}"

  services = [
    "cloudbuild.googleapis.com",
    "pubsub.googleapis.com",
    "dns.googleapis.com",
    "storage-component.googleapis.com",
    "oslogin.googleapis.com",
    "bigquery-json.googleapis.com",
    "containerregistry.googleapis.com",
    "compute.googleapis.com",
    "deploymentmanager.googleapis.com",
    "replicapool.googleapis.com",
    "replicapoolupdater.googleapis.com",
    "resourceviews.googleapis.com",
    "cloudtrace.googleapis.com",
    "monitoring.googleapis.com",
    "stackdriver.googleapis.com",
    "logging.googleapis.com",
    "container.googleapis.com",
    "storage-api.googleapis.com",
  ]
}

