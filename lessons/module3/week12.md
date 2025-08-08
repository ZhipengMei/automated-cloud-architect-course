# Module 3, Week 12: The Dynamic Duo - Managing Helm Releases with Terraform

Welcome to Week 12. This is where we unify our two major workflows. We have our infrastructure (like a Kubernetes cluster) managed by Terraform. We have our application packaged as a Helm chart.

How do we deploy our application onto our infrastructure? We could use the `helm` CLI, but that would be another manual step. Instead, we will use **Terraform to manage our Helm releases**, creating a single, unified, and declarative workflow for the entire environment.

---

## Session 1: The Problem - Two Separate Workflows

Currently, we have two distinct "worlds":

1.  **The Terraform World:** Manages the underlying infrastructure (VPCs, Kubernetes clusters, databases).
2.  **The Helm World:** Manages the applications running *on* that infrastructure.

Keeping these separate requires manual handoffs. An engineer would first run `terraform apply` to create a cluster, and then run `helm install` to deploy the application. This is inefficient and breaks our "fully automated" goal.

---

## Session 2: The Terraform Helm Provider

To bridge this gap, we use the official **Helm Provider for Terraform**. This provider gives Terraform a new resource type: `helm_release`.

This `helm_release` resource allows you to do everything you would normally do with the Helm CLI, but in a declarative Terraform file. You can specify the chart name, version, repository, and a set of `values` to apply.

*   **The Power of Unification:** When you run `terraform apply`, Terraform will now:
    1.  Provision the Kubernetes cluster.
    2.  Install the Helm provider.
    3.  Deploy your application onto that cluster using the specified Helm chart.

The entire state of your environment, from the network layer all the way up to the running application, is now managed in a single, declarative workflow.

---

## Lab 12: Deploying a Helm Chart with Terraform

**Objective:** To use Terraform to deploy a Helm chart onto a Kubernetes cluster. For this lab, we'll continue to use our local Kubernetes cluster, but the same principle applies to a cloud-based cluster managed by Terraform.

**Prerequisites:**
*   Your local Kubernetes cluster (e.g., from Docker Desktop) must be running.
*   Your `hello-world-chart` from last week should be available locally.

**Your Task:**

1.  **Create a new Terraform project:**
    *   Create a new directory named `terraform-helm-deploy`.
    *   `cd` into this new directory.

2.  **Create `main.tf`:**
    *   Create a file named `main.tf`. We need to configure two providers: one for Kubernetes and one for Helm.

    ```hcl
    # Configure the Kubernetes provider to connect to your local cluster
    provider "kubernetes" {
      config_path = "~/.kube/config" # Assumes default kubeconfig location
    }

    # Configure the Helm provider
    provider "helm" {
      kubernetes {
        config_path = "~/.kube/config" # Tell Helm how to connect to K8s
      }
    }

    # Define the Helm release resource
    resource "helm_release" "hello_world" {
      name       = "hello-from-terraform"
      chart      = "../path/to/your/hello-world-chart" # IMPORTANT: Update this path

      # You can override values from the chart's values.yaml here
      values = [
        file("../path/to/your/hello-world-chart/values.yaml")
      ]

      # Example of setting a single value
      set {
        name  = "replicaCount"
        value = "3"
      }
    }

    # Output the status of the release
    output "release_status" {
      value = helm_release.hello_world.status
    }
    ```
    *   **IMPORTANT:** You must update the `chart` and `values` paths to point to the correct location of your `hello-world-chart` directory from last week's lab.

3.  **Run the Terraform Workflow:**
    *   Initialize Terraform:
        ```bash
        terraform init
        ```
    *   Create a plan. It should show that it will add 1 new `helm_release` resource.
        ```bash
        terraform plan
        ```
    *   Apply the plan:
        ```bash
        terraform apply -auto-approve
        ```

4.  **Verify the Deployment:**
    *   Use `helm` and `kubectl` to verify that Terraform did its job.
        ```bash
        helm list
        # You should see the "hello-from-terraform" release

        kubectl get deployment
        # You should see the "hello-from-terraform-hello-world-chart" deployment with 3 replicas
        ```

5.  **Manage the Release with Terraform:**
    *   Go back to your `main.tf` file and change the `replicaCount` value from `3` to `5`.
    *   Run `terraform apply -auto-approve` again.
    *   Run `kubectl get deployment`. You will see that the number of replicas has been updated to 5. Terraform has intelligently upgraded the Helm release.

6.  **Clean Up:**
    *   Destroy the release using Terraform:
        ```bash
        terraform destroy -auto-approve
        ```

You have now achieved a massive milestone: managing the entire lifecycle of your application and its underlying infrastructure from a single, unified, declarative workflow.
