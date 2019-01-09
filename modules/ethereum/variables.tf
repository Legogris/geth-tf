variable "miner_count" {
    default = 0
}

variable "bootnode_count" {
}

variable "network_id" {}
variable "genesis_difficulty" {}
variable "genesis_gas_limit" {}
variable "google_project" {}
variable "google_org_id" {}
variable "google_billing_account" {}
variable "zone" {
    default = "us-east1-b"
}
variable "alternative_zone" {
    default = "us-east1-c"
}
variable "cluster_machine_type" {
    default = "n1-standard-2"
}

variable ethereum_account_address {}
variable ethereum_account_key {}
variable ethereum_account_secret {}
variable bootnodes {
    default = ["`cat /root/.ethereum/bootnodes`"]
}