
# IAM from for the eks cluster master

resource "aws_iam_role" "masterIAM"{
    name = "eks-cluster-lab"

    assume_role_policy = <<POLICY
{
        "Version": "2012-10-17",
        "Statement":[
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            }
        }]
    }
    POLICY
}

resource "aws_iam_role_policy_attachment" "master-EKSCluster" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.masterIAM.name
}

resource "aws_iam_role_policy_attachment" "master-EKSVPCResource" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
    role = aws_iam_role.masterIAM.name
}


# IAM Role for eks cluster node groups

resource "aws_iam_role" "workerNodes"{
    name = "eks-workerNodes"

    assume_role_policy = <<POLICY
{
        "Version": "2012-10-17",
        "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            }
        }
        ]
    }
    POLICY
}

resource "aws_iam_role_policy_attachment" "workernodes-CNI-Policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.workerNodes.name
}

resource "aws_iam_role_policy_attachment" "workernodes-EC2Container" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.workerNodes.name
}

resource "aws_iam_role_policy_attachment" "workernodes-EKSWorkerNode" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.workerNodes.name
}