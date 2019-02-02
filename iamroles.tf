resource "aws_iam_role" "ec2_s3_access_role" {
  name               = "s3-role"
  assume_role_policy = "${file("assumerolepolicy.json")}"
}

resource "aws_iam_policy" "policy" {
  name        = "s3-read-policy"
  description = "A s3 read policy"
  policy      = "${file("policys3bucket.json")}"
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = ["${aws_iam_role.ec2_s3_access_role.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_iam_instance_profile" "test_profile" {
  name  = "tf_instance_profile"
  role  = "${aws_iam_role.ec2_s3_access_role.name}"
}
