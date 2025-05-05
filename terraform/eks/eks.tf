resource "aws_default_vpc" "default" {

}

resource "aws_eks_cluster" "cluster" {
    name = "devops-cluster"
    role_arn = aws_iam_role.cluster_role.arn
    depends_on = [aws_iam_role_policy_attachments_exclusive.cluster_role_policy]
    vpc_config {
        endpoint_private_access = true
        endpoint_public_access = true #not safe, use to test from local

        subnet_ids = var.public_subnetid
        #vpc_id = aws_default_vpc.default
    }
}

resource "aws_iam_role" "cluster_role" {
    name = "devops_cluster_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "sts:AssumeRole",
                    "sts:TagSession"
                ]
                Effect = "Allow"
                Principal = {
                    Service = [
                        "eks.amazonaws.com",
                        "ec2.amazonaws.com"
                    ]
                }
            },
        ]
    })
}

resource "aws_iam_role_policy_attachments_exclusive" "cluster_role_policy" {
    policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
    role_name = aws_iam_role.cluster_role.name
}

#Node-Group

resource "aws_eks_node_group" "node_group" {
    cluster_name = aws_eks_cluster.cluster.name
    node_role_arn = aws_iam_role.node_group_role.arn
    scaling_config {
        desired_size = 1
        min_size = 1
        max_size = 2
    }
    instance_types = ["t3.medium"]
    subnet_ids = var.public_subnetid
    depends_on = [
        aws_iam_role_policy_attachments_exclusive.node_group_policy,
        aws_iam_role_policy_attachments_exclusive.node_group_policy1,
        aws_iam_role_policy_attachments_exclusive.node_group_policy2,
        aws_iam_role_policy_attachments_exclusive.node_group_policy3,
        aws_eks_cluster.cluster
    ]
}

resource "aws_iam_role" "node_group_role" {
    name = "devops_cluster_ng_role"
    assume_role_policy = jsonencode({
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
        Version = "2012-10-17"
    })
}

resource "aws_iam_role_policy_attachments_exclusive" "node_group_policy" {
    policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"]
    role_name = aws_iam_role.node_group_role.name
}

resource "aws_iam_role_policy_attachments_exclusive" "node_group_policy1" {
    role_name = aws_iam_role.node_group_role.name
    policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"]
}

resource "aws_iam_role_policy_attachments_exclusive" "node_group_policy2" {
    role_name = aws_iam_role.node_group_role.name
    policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
}

resource "aws_iam_role_policy_attachments_exclusive" "node_group_policy3" {
    role_name = aws_iam_role.node_group_role.name
    policy_arns = ["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]
}