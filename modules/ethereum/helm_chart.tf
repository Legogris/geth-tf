resource "helm_release" "ethereum" {
  name    = "ethereum"
  chart   = "../../../charts/ethereum"
  version = "0.1.5-41"
  depends_on = [
    "google_container_node_pool.np-1",
    "kubernetes_cluster_role_binding.kube_system_default_admin"
  ]

  # resources values
  set {
    name  = "geth.miner.replicaCount"
    value = "${var.miner_count}"
  }

  set {
    name  = "bootnode.replicaCount"
    value = "${var.bootnode_count}"
  }

  set {
    name  = "geth.tx.replicaCount"
    value = "1"
  }

  # set {
  #   name  = "geth.genesis.networkId"
  #   value = "${var.network_id}"
  # }

  set {
    name  = "geth.genesis.difficulty"
    value = "${var.genesis_difficulty}"
  }

  set {
    name  = "geth.genesis.gasLimit"
    value = "${var.genesis_gas_limit}"
  }

  set {
    name = "geth.account.address"
    value = "${var.ethereum_account_address}"
  }

  set {
    name = "geth.account.privateKey"
    value = "${var.ethereum_account_key}"
  }

  set {
    name = "geth.account.secret"
    value = "${var.ethereum_account_secret}"
  }

  set {
    name = "geth.image.tag"
    value = "v1.8.23"
  }

  set {
    name = "geth.tx.requests.cpu"
    value = "90m"
  }

  set {
    name = "geth.tx.limits.cpu"
    value = "90m"
  }

  set {
    name = "geth.tx.requests.memory"
    value = "2048Mi"
  }

  set {
    name = "geth.tx.limits.memory"
    value = "2048Mi"
  }

  set {
    name = "bootnode.image.tag"
    value = "alltools-v1.8.23"
  }

  set {
    name = "ethstats.limits.memory"
    value = "400Mi"
  }

  set {
    name = "ethstats.requests.memory"
    value = "256Mi"
  }

  set {
    name = "ethstats.requests.cpu"
    value = "80m"
  }

  set_string {
    name  = "geth.bootnodes"
    value = "${join("\\,", "${var.bootnodes}")}"
  }
}

resource "null_resource" "helm_update" {
  depends_on = ["helm_release.ethereum"]
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "helm repo update"
  }
}
