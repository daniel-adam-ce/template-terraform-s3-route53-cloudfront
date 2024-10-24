# Route 53 + S3 + CloudFront Terraform Template

This template creates a S3 bucket, a CloudFront distribution, and Route 53 records for an an existing hosted zone.

## Usage

To use this template, follow these steps:

1. Clone the repository to your local machine.
2. Create a "terraform.tfvars" file in the root of the repository and add the following variables:
    * bucket_name: The name of the S3 bucket.
    * bucket_domain_name: The domain name for the S3 bucket.
    * domain_name: The domain name for the Route 53 hosted zone.
    * acm_cert: The ARN of the ACM certificate for the CloudFront distribution.
    * route53_zone_id: The ID of the Route 53 hosted zone that will be used.
3. Run `terraform init` to initialize the Terraform configuration.
    * Note that this repo uses HashiCorp Cloud Patform Terraform. If you do not wish to use this, you will need to configure the provider.tf file accordingly.
    * If you wish to use HashiCorp Cloud Platform, you will need to create an organization and workspace. See the [HCP Terraform documentation](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started) for more information.
4. Run `terraform plan` to see the changes that will be made.
5. Run `terraform apply` to apply the changes.
    * CloudFront distributions take a few minutes to provision.
6. Verify that the S3 bucket, CloudFront distribution, and Route 53 records were created.
7. You should be able to access the website at the domain name you specified.

## Cleanup

1. To clean up all resources created by this template, run `terraform destroy`.
    * CloudFront distributions take a few minutes to destroy.

## Notes

* This template assumes that you have already created a hosted zone in Route 53.
* This template also assumes that you have already created an ACM certificate in AWS Certificate Manager for the domain name.
* This template is <i>not</i> intended to be used as a complete solution for hosting a static website. It is intended to be used as a starting point to learn Terraform and to deploy a simple static website.
