# Module 3, Week 9: The Blueprint - Introduction to Terraform

Welcome to Module 3. We have mastered the art of creating a secure, versioned software artifact. But where do we run it? We need infrastructure: networks, servers, and Kubernetes clusters.

In the past, this infrastructure was provisioned manually via cloud console GUIs, a process that is slow, error-prone, and impossible to track. We will treat our infrastructure the same way we treat our application: as code. This practice is called **Infrastructure as Code (IaC)**, and our tool is **Terraform**.

---

## Session 1: What is Infrastructure as Code?

**Infrastructure as Code (IaC)** is the practice of managing and provisioning computer data centers through machine-readable definition files, rather than physical hardware configuration or interactive configuration tools.

*   **Declarative vs. Imperative:**
    *   **Imperative (The "How"):** A script that says "create a server, then configure a network, then attach the server." You define the steps.
    *   **Declarative (The "What"):** A configuration file that says "I want one server with this configuration and one network with these settings." You define the desired end state, and the tool figures out how to get there.
*   **Terraform is declarative.** This is incredibly powerful because it can calculate the difference between the desired state (your code) and the actual state (in the cloud) and create a plan to resolve it.

---

## Session 2: The Terraform Workflow

Terraform has a simple, predictable workflow that you will use constantly.

1.  **Write:** You define your infrastructure in `.tf` files using HashiCorp Configuration Language (HCL).
2.  **Init:** You run `terraform init` in your directory. Terraform downloads the necessary **providers** (e.g., for AWS, Azure, Google Cloud) that understand how to interact with that specific cloud's API.
3.  **Plan:** You run `terraform plan`. Terraform reads your code, inspects the current state of your infrastructure, and presents a plan of what it will **create, update, or destroy**. This step is crucial for safety and peer review.
4.  **Apply:** You run `terraform apply`. Terraform executes the plan, making the necessary API calls to the cloud provider to configure the infrastructure.

Terraform records the state of the infrastructure it manages in a file called `terraform.tfstate`. This file is critical and acts as a map between your code and the real-world resources.

---

## Session 3: Core Terraform Concepts

*   **Providers:** Plugins that define resources for a specific service (e.g., `aws`, `google`, `kubernetes`). You declare which providers you need in your configuration.
*   **Resources:** The most important concept. A resource block defines a piece of infrastructure, like a virtual machine (`aws_instance`), a VPC network (`aws_vpc`), or a Kubernetes cluster (`aws_eks_cluster`).
*   **Data Sources:** Allow you to fetch information from outside of Terraform, like the ID of the latest Amazon Linux AMI.
*   **Variables:** Used to parameterize your configuration, making it reusable (e.g., defining `variable "region" {}`).
*   **Outputs:** Used to extract information from your configuration to be used elsewhere (e.g., the public IP address of a server you just created).

---

## Lab 9: Provisioning Your First Cloud Resource

**Objective:** To use Terraform to define and create a real resource in a cloud provider. We will use AWS as an example.

**Prerequisites:**
*   An AWS account.
*   The AWS CLI installed and configured with your credentials (`aws configure`).
*   Terraform installed on your local machine.

**Your Task:**

1.  **Set up a new directory:**
    *   Outside of your `automated-cloud-architect-course` repository, create a new directory called `terraform-basics`. We keep IaC separate from application code.
    *   `cd` into this new directory.

2.  **Create `main.tf`:**
    *   Create a file named `main.tf` and add the following content. This code tells Terraform we want to use the AWS provider and create a single S3 bucket.

    ```hcl
    # Configure the AWS provider
    provider "aws" {
      region = "us-west-2"
    }

    # Define a variable for the bucket name to ensure it's unique
    variable "bucket_name" {
      description = "The name of the S3 bucket"
      type        = string
      default     = "my-unique-terraform-bucket-12345" # CHANGE THIS!
    }

    # Create an S3 bucket resource
    resource "aws_s3_bucket" "my_bucket" {
      bucket = var.bucket_name

      tags = {
        Name        = "My Terraform Bucket"
        Environment = "Dev"
      }
    }

    # Output the name of the bucket
    output "bucket_name" {
      value = aws_s3_bucket.my_bucket.bucket
    }
    ```
    *   **IMPORTANT:** You MUST change the default value of `bucket_name` to something globally unique.

3.  **Run the Terraform Workflow:**
    *   Initialize Terraform:
        ```bash
        terraform init
        ```
    *   Create a plan:
        ```bash
        terraform plan
        ```
        *   Review the output. It should tell you it plans to add 1 resource.
    *   Apply the plan:
        ```bash
        terraform apply
        ```
        *   Terraform will show you the plan again and ask for confirmation. Type `yes`.

4.  **Verify in AWS:**
    *   Log in to your AWS console, navigate to S3, and you will see the bucket you just created.

5.  **Destroy the Infrastructure:**
    *   To clean up and avoid costs, use the `destroy` command.
        ```bash
        terraform destroy
        ```
        *   Confirm by typing `yes`.

You have now successfully managed cloud infrastructure using code, the foundational skill for automating your entire environment.
