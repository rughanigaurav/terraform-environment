resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "mybucket" {

  bucket = "mybucket"

  tags = {

      Name="mybucket"

  }

}

  resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.mybucket.id
  acl    = "private"
}

   resource "aws_s3_bucket_versioning" "versioning" {

    bucket = aws_s3_bucket.mybucket.id
    versioning_configuration {
    status = "Enabled"
  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "test" {

    bucket = aws_s3_bucket.mybucket.id

    rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket" "access_logs" {

    bucket = "access_logs"

    tags = {

      Name="accesslog"

    }
}

resource "aws_s3_bucket_versioning" "versioning2" {

        bucket = aws_s3_bucket.access_logs.id

        versioning_configuration {
          status = "Enabled"
        }

      }

resource "aws_s3_bucket_server_side_encryption_configuration" "example2" {

        bucket = aws_s3_bucket.access_logs.id

        rule {
    apply_server_side_encryption_by_default {

      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"

    }
  }
}

data "aws_iam_policy_document" "s3_bucket_lb_write" {
  policy_id = "s3_bucket_lb_logs"

  statement {
    actions = [
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.access_logs.arn}/*",
    ]

  }

  statement {
    actions = [
      "s3:PutObject"
    ]
    effect = "Allow"
    resources = ["${aws_s3_bucket.access_logs.arn}/*"]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }

  statement {
    actions = [
      "s3:GetBucketAcl"
    ]
    effect = "Allow"
    resources = ["${aws_s3_bucket.access_logs.arn}"]

  }
}