locals {
  gke_subnetwork          = module.network.subnets_names[0]
  gke_pods_range_name     = module.network.subnets_secondary_ranges[0][0].range_name
  gke_services_range_name = module.network.subnets_secondary_ranges[0][1].range_name
}

module "gke" {
  source                   = "terraform-google-modules/kubernetes-engine/google"
  project_id               = local.project_id
  region                   = local.region
  name                     = local.name_prefix
  regional                 = false
  release_channel          = "STABLE"
  network                  = module.network.network_name
  subnetwork               = local.gke_subnetwork
  ip_range_pods            = local.gke_pods_range_name
  ip_range_services        = local.gke_services_range_name
  create_service_account   = true
  remove_default_node_pool = true

  node_pools = [
    {
      name         = "default"
      machine_type = "e2-standard-4"
      min_count    = 0
      max_count    = 3
    }
  ]
}


