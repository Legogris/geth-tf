resource "google_container_cluster" "main" {
  name    = "gke-main-1"
  project = "${google_project.project.project_id}"
  zone    = "${var.zone}"
  depends_on = [
    "google_project_services.project",
    "google_project_iam_member.project"
  ]

  additional_zones = [
     # "${var.alternative_zone}",
  ]

  initial_node_count       = 1
  remove_default_node_pool = true

  monitoring_service = "monitoring.googleapis.com"

  maintenance_policy {
    daily_maintenance_window {
      start_time = "11:00"
    }
  }

  ip_allocation_policy {
    create_subnetwork = "true"
  }

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.main.name} --region ${var.zone} --project ${google_project.project.project_id}"
  }
}

resource "google_container_node_pool" "np-1" {
  project            = "${google_project.project.project_id}"
  cluster            = "${google_container_cluster.main.name}"
  zone               = "${var.zone}"
  # initial_node_count = 1
  max_pods_per_node  = 110

  node_count = 1
  # autoscaling {
  #   min_node_count = 1
  #   max_node_count = 2
  # }

  node_config {
    machine_type = "${var.cluster_machine_type}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/compute",
    ]

    local_ssd_count = 1
    # labels {
    #   stack = "${var.stack}"
    # }

    # tags = ["${var.stack}"]
  }
}

resource "kubernetes_cluster_role_binding" "kube_system_default_admin" {
  depends_on = ["google_container_cluster.main"]
  metadata {
      name = "kube-system-default-admin"
  }
  role_ref {
      api_group = "rbac.authorization.k8s.io"
      kind = "ClusterRole"
      name = "cluster-admin"
  }
  subject {
      kind = "ServiceAccount"
      name = "default"
      namespace = "kube-system"
  }
}
# kubectl create rolebinding default-view --clusterrole=view --serviceaccount=kube-system:default --namespace=kube-system