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
  network_id = 4
  genesis_difficulty = "0x1"
  genesis_gas_limit = "0x47b760"
  bootnode_count = 0
  miner_count = 0
  ethereum_account_address = "0x3c5A9F82701f627935b94DA03F019625464331B3"
  ethereum_account_key = "18e54b377f69fb82bfa092082536dacf9256cf07be0cc32b2000a7fbf0a48eba"
  ethereum_account_secret = "hejhoppilingonskogen"
  bootnodes = [
    "enode://a24ac7c5484ef4ed0c5eb2d36620ba4e4aa13b8c84684e1b4aab0cebea2ae45cb4d375b77eab56516d34bfbd3c1a833fc51296ff084b770b94fb9028c4d25ccf@52.169.42.101:30303",
    "enode://343149e4feefa15d882d9fe4ac7d88f885bd05ebb735e547f12e12080a9fa07c8014ca6fd7f373123488102fe5e34111f8509cf0b7de3f5b44339c9f25e87cb8@52.3.158.184:30303",
    "enode://b6b28890b006743680c52e64e0d16db57f28124885595fa03a562be1d2bf0f3a1da297d56b13da25fb992888fd556d4c1a27b1f39d531bde7de1921c90061cc6@159.89.28.211:30303"
  ]
}

