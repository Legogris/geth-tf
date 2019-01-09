# -- Backend -----------------------------------------------

terraform {
  required_version = "~> 0.11"
}

# -- Provider ----------------------------------------------

provider "google" {
  credentials = "${file("~/.config/gcloud/kaiko-terraform-admin.json")}"
  project     = "${var.google_project}"
  version     = "1.18.0"
}

provider "kubernetes" {
  version        = "1.2.0-custom"
  config_context = "gke_kaiko-workshop-kovan-1_us-east1-b_gke-main-1"
}

provider "helm" {
  install_tiller = true
  version = "0.8.0"
  kubernetes {
      config_context = "gke_kaiko-workshop-kovan-1_us-east1-b_gke-main-1"
  }
}


# -- atsume stack -----------------------------------------

module "ethereum" {
  source = "../../modules/ethereum"

  # -- global.tfvars
  google_org_id          = "${var.google_org_id}"
  google_billing_account = "${var.google_billing_account}"
  google_project         = "${var.google_project}"

  # -- terraform.tfvars
  network_id = 12345
  bootnode_count = 1
  miner_count = 1
  genesis_difficulty = "0x1"
  genesis_gas_limit = "0x47b760"
  ethereum_account_address = "0x3c5A9F82701f627935b94DA03F019625464331B3"
  ethereum_account_key = "18e54b377f69fb82bfa092082536dacf9256cf07be0cc32b2000a7fbf0a48eba"
  ethereum_account_secret = "hejhoppilingonskogen"
}

