# Module 4, Week 13: The Final Piece - Continuous Deployment with Argo CD

Welcome to the final module. We have automated our CI pipeline to produce a secure container image. We have automated our infrastructure with Terraform. But one crucial piece is missing: **Continuous Deployment (CD)**.

How does a new version of our application, represented by a new container image tag, get deployed to our Kubernetes cluster automatically? The answer is **GitOps**, and our tool is **Argo CD**.

---

## Session 1: What is GitOps?

GitOps is a paradigm for managing Kubernetes cluster and application delivery. It builds on DevOps and IaC principles and has a simple, core idea:

**Your Git repository is the *only* source of truth for the desired state of your entire system.**

*   **The Old Way (Push-based CD):** Your CI pipeline (e.g., GitHub Actions) would end with a `kubectl apply` or `helm upgrade` command, actively *pushing* changes into the cluster. This requires your CI system to have powerful credentials to the cluster, which is a security risk.
*   **The GitOps Way (Pull-based CD):** A tool *inside* the cluster, called an operator, constantly watches a Git repository. When it detects a difference between the state defined in Git and the actual state of the cluster, it *pulls* the changes in and applies them.

This "pull" model is more secure, more robust, and provides a perfect audit trail in your Git history.

---

## Session 2: Introduction to Argo CD

**Argo CD** is the leading GitOps tool for Kubernetes. It is a controller that you install in your cluster.

*   **How it Works:**
    1.  You define an `Application` resource in a YAML file. This is a Custom Resource Definition (CRD) that Argo CD provides.
    2.  In the `Application` manifest, you tell Argo CD:
        *   The **source** Git repository to watch (e.g., your Helm chart repository).
        *   The **path** within that repository to find the manifests.
        *   The **destination** Kubernetes cluster and namespace to deploy to.
        *   The **sync policy** (e.g., whether to apply changes automatically).
    3.  Argo CD constantly compares the live state of the cluster with the state defined in the specified Git repository.
    4.  If they are different, Argo CD reports the application as `OutOfSync`. If automatic sync is enabled, it will apply the changes to bring the application back to the `Synced` state.

---

## Lab 13: (Conceptual) Deploying with Argo CD

**Objective:** To understand the Argo CD workflow by mapping it out. A full Argo CD installation is complex, but we can trace the entire process.

**Your Task:**

This lab connects all the pieces of our course. You will diagram the final, end-to-end workflow.

1.  **Create three repositories on GitHub:**
    *   `hello-world-app`: Our application code.
    *   `hello-world-chart`: Our Helm chart.
    *   `hello-world-manifests`: A new repository. This will be the "source of truth" repository that Argo CD watches.

2.  **Diagram the End-to-End Workflow:**
    *   Create a diagram or text flow that shows the complete lifecycle of a change, starting with a developer and ending with a live deployment.

    *   **Part 1: The CI Pipeline (Application Change)**
        1.  **Developer** makes a code change in the `hello-world-app` repository.
        2.  **GitHub Actions** runs the CI pipeline from Week 8.
        3.  The pipeline builds and pushes a new, uniquely tagged container image to the registry (e.g., `ghcr.io/user/hello-world-app:f2a4b...`).

    *   **Part 2: The CD Pipeline (Configuration Change)**
        1.  **Developer** (or an automated process) opens a Pull Request in the `hello-world-manifests` repository.
        2.  In this PR, they update a `values.yaml` file to change the `image.tag` to the new Git SHA from Part 1 (`f2a4b...`).
        3.  The PR is reviewed and merged into the `main` branch.

    *   **Part 3: The GitOps Sync (Argo CD's Job)**
        1.  **Argo CD**, which is running in the Kubernetes cluster, is configured to watch the `main` branch of the `hello-world-manifests` repository.
        2.  It detects that the `image.tag` in the repository has changed and no longer matches the tag running in the cluster.
        3.  Argo CD's status changes to `OutOfSync`.
        4.  Because auto-sync is enabled, Argo CD runs `helm template` with the new values and applies the resulting change to the cluster.
        5.  Kubernetes performs a rolling update of the Deployment, replacing the old Pods with new ones running the new container image.
        6.  Argo CD's status returns to `Synced`.

This complete, automated loop is the pinnacle of a modern cloud-native platform. The developer's only job was to write code and update a configuration value; the platform handled the rest.
