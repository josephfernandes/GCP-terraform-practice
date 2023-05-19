provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = file("../credentials.json")
}
resource "google_project_iam_member" "dev-engineers" {
  for_each = toset([
    "roles/notebooks.admin",
    "roles/ml.admin",
    "roles/aiplatform.admin",
    "roles/cloudbuild.builds.viewer",
    "roles/documentai.editor",
    "roles/compute.admin"
  ])
  project = "terraform-378715"
  role    = each.value
  member  = "user:ganesh.ransarje@kpmg.co.uk"
}
resource "google_compute_instance" "my_test_instance" {
  name         = "test-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"
}
