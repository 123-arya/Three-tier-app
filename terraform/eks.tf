module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = local.name
  kubernetes_version = var.cluster_version

  endpoint_public_access  = true     #(allows system to connect with cluster)
  endpoint_private_access = true     #(vpc access)

  enable_cluster_creator_admin_permissions = true      #(IAM user who creates the cluster automatically becomes the Kubernetes administrator.)
  enable_irsa                              = true       #(IRSA stands for IAM Roles for Service Accounts.)

  # EKS Add-ons (latest versions auto-resolved)
  addons = {
    coredns = {                 # CoreDNS works like a phonebook.
      most_recent = true
    }
    kube-proxy = {                     # kube-proxy sends traffic to the correct pod.
      most_recent = true
    }
    vpc-cni = {              #CNI gives IP addresses to pods.
      most_recent    = true
      before_compute = true
    }
    eks-pod-identity-agent = {             #This is the newer AWS method for giving pods IAM permissions.
      most_recent    = true
      before_compute = true
    }
    aws-ebs-csi-driver = {                  # Suppose MySQL needs storage.
      most_recent              = true
      service_account_role_arn = module.ebs_csi_irsa.iam_role_arn
    }
    metrics-server = {         # Collects CPU and memory usage.
      most_recent = true
    }
  }

  # Networking
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # Managed Node Group
  eks_managed_node_groups = {
    skillpulse-ng = {
      instance_types = [var.node_instance_type]
      desired_size   = var.node_desired_count
      min_size       = var.node_desired_count
      max_size       = var.node_max_count
    }
  }

  tags = local.tags
}

# IRSA for EBS CSI Driver (needed to create/attach EBS volumes)
module "ebs_csi_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name             = "${local.name}-ebs-csi"
  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = local.tags
}