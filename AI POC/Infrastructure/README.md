

## This Terraform setup provisions the following resources in Google Cloud Platform (GCP):

Google Cloud Storage (GCS) Bucket (for metadata and PDF storage)

API Enablement (to enable required GCP services)

IAM Permissions (to assign roles to users and service accounts)


## Directory Structure

```console
.
├── API/                  # API enablement module
│   ├── main.tf
│   ├── variables.tf
├── GCS/                  # GCS bucket provisioning module
│   ├── main.tf
│   ├── variables.tf
├── IAM/                  # IAM roles and permissions module
│   ├── main.tf
│   ├── variables.tf
├── modules/              # Reusable Terraform modules
│   ├── api/              # API enablement module
│   ├── gcs/              # GCS module
│   ├── iam/              # IAM module
├── provider.tf           # Provider configuration
├── terraform.tfvars      # User-defined variable values (DO NOT COMMIT)
── .gitignore            # Git ignore file
── README.md             # Documentation (this file)

```
## Resources Provisioned

1. Google Cloud Storage (GCS) Buckets

Creates storage buckets for storing metadata and PDF files.

Managed under the GCS/ and modules/gcs/ directories.

2. API Enablement

Enables required Google Cloud APIs.

Defined in the API/ and modules/api/ directories.

3. IAM Role Assignments

Assigns IAM roles to:

Service accounts (for automated execution)

Users (for management and deployment)

IAM roles are managed in the IAM/ and modules/iam/ directories.

## Authentication

Run the following command to authenticate your local machine with Google Cloud:

```console
gcloud auth application-default login

```
This allows Terraform to interact with GCP resources using your credentials.

## Terraform Usage

1. Initialize Terraform

Run the following command to initialize Terraform:

```console
terraform init

```
2. Format Terraform Code

Ensure all Terraform files follow proper formatting:

```console
terraform fmt -recursive

```
3. Validate Configuration

Check for syntax errors and misconfigurations:

```console
terraform validate

```
4. Plan Deployment

Preview changes before applying them:

```console
terraform plan -var-file="../terraform.tfvars"

```
5. Apply Changes

Deploy resources to GCP:

```console
terraform apply -var-file="../terraform.tfvars"

```
6. Destroy Resources (If Needed)

To remove all provisioned resources:

```console
terraform destroy -var-file="../terraform.tfvars"
```

## Git Workflow

1. Exclude Unwanted Files

Ensure Terraform state files and sensitive data are ignored by adding the following to .gitignore:

```console
.terraform/
*.tfstate
*.tfstate.backup
.terraform.lock.hcl
terraform.tfvars
```
2. Commit and Push Changes

```console
git add .
git commit -m "Provisioning GCP resources with Terraform"
git push u origin main
```
## References

[Google Cloud Terraform Provider
]([https://](https://registry.terraform.io/providers/hashicorp/google/latest/docs))

