
# create eks cluster

resource "aws_eks_cluster" "jenkins-eks-lab" {
    name = "jenkins-eks-lab"
    role_arn = aws_iam_role.masterIAM.arn

    vpc_config {
        subnet_ids = [aws_subnet.newSubnet-1.id, aws_subnet.newSubnet-2.id]
    }

    depends_on = [
        aws_iam_role_policy_attachment.master-EKSCluster,
        aws_iam_role_policy_attachment.master-EKSVPCResource
    ]
}

# create helper nodes for the cluster

resource "aws_eks_node_group" "helperNodes" {
    cluster_name = aws_eks_cluster.jenkins-eks-lab.name
    node_group_name = "helperNodes"
    node_role_arn = aws_iam_role.workerNodes.arn
    subnet_ids = [aws_subnet.newSubnet-1.id, aws_subnet.newSubnet-2.id]

    scaling_config {
        desired_size = 2
        max_size = 2
        min_size = 2
    }

    ami_type = "AL2_x86_64"
    instance_types = ["t2.micro"]
    capacity_type = "ON_DEMAND"
    disk_size = 20

    depends_on = [
        aws_iam_role_policy_attachment.workernodes-CNI-Policy,
        aws_iam_role_policy_attachment.workernodes-EC2Container,
        aws_iam_role_policy_attachment.workernodes-EKSWorkerNode
    ]
}