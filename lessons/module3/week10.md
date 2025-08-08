# Module 3, Week 10: The Collaborative Workflow - Automating Terraform with Atlantis

Welcome to Week 10. We can now write Terraform code, but we've only run it from our local machine. This doesn't scale for a team and is dangerous. How do we review infrastructure changes? How do we ensure only approved changes are applied? How do we manage the critical `tfstate` file?

We solve this by automating Terraform within a Git-based, pull request workflow. Our tool for this is **Atlantis**.

---

## Session 1: The Problem with "Terraform on Your Laptop"

Running `terraform apply` from your local machine presents several major problems in a team environment:

*   **State File Drift:** If each team member has a copy of the `tfstate` file, they will quickly become out of sync, leading to conflicts and accidental resource deletion. The state file *must* be stored in a shared, remote location (like an S3 bucket).
*   **No Peer Review:** A developer can apply a major, breaking change to production infrastructure without anyone else reviewing it.
*   **Lack of Audit Trail:** Who applied what change, and when? It's difficult to track.
*   **Credential Management:** Every developer needs highly privileged cloud credentials on their local machine, which is a significant security risk.

---

## Session 2: The GitOps Approach to Infrastructure

We will apply the same GitOps principles we use for our application to our infrastructure code.

*   **Git is the source of truth:** The `main` branch of our Terraform repository represents the desired state of our production infrastructure.
*   **All changes happen via Pull Request:** No one applies changes from their laptop. All changes are proposed in a feature branch and reviewed in a PR.
*   **The PR is the new `plan`:** The `terraform plan` output should be automatically posted as a comment in the PR for everyone to see.
*   **Merging is the new `apply`:** Merging the PR should trigger the `terraform apply` command.

This workflow provides the safety, auditability, and collaboration that is missing from the local workflow.

---

## Session 3: Introduction to Atlantis

**Atlantis** is an open-source application that automates your Terraform workflow. It listens for GitHub webhooks and lets you run Terraform commands directly from your pull requests.

*   **How it Works:**
    1.  You install Atlantis and configure it to run somewhere (e.g., on a small VM or in your Kubernetes cluster).
    2.  You configure your GitHub repository to send webhook events to your Atlantis instance.
    3.  A developer opens a PR with a change to a `.tf` file.
    4.  The developer comments `atlantis plan` on the PR.
    5.  Atlantis runs `terraform plan` in a temporary directory and posts the output back as a comment on the PR.
    6.  The team reviews the plan. If it looks good, a team member with approval rights comments `atlantis apply`.
    7.  Atlantis runs `terraform apply` and posts the output.
    8.  The PR can now be merged.

Atlantis becomes the single, secure place where Terraform commands are executed, solving all the problems of the local workflow.

---

## Lab 10: (Conceptual) Designing an Atlantis Workflow

**Objective:** To understand and design the workflow for managing infrastructure changes with Atlantis. Actually setting up Atlantis is beyond the scope of this lab, but we will map out the process.

**Your Task:**

1.  **Create a new repository for infrastructure:**
    *   On GitHub, create a new repository named `my-infra-code`.
    *   Add the `main.tf` file from last week's lab to this repository.

2.  **Diagram the Workflow:**
    *   Using a text file, Markdown, or a diagramming tool, map out the entire lifecycle of an infrastructure change using Atlantis. Your diagram should include the following actors and steps:
        *   **Developer:**
            1.  Creates a new branch (`feature/add-s3-website`).
            2.  Modifies `main.tf` to configure the S3 bucket for static website hosting.
            3.  Pushes the branch and opens a Pull Request.
            4.  Comments `atlantis plan` on the PR.
        *   **Atlantis:**
            1.  Receives the webhook.
            2.  Runs `terraform plan`.
            3.  Posts the plan output as a PR comment. The plan should show that it will modify 1 resource.
        *   **Team Lead:**
            1.  Reviews the code changes and the plan.
            2.  Approves the PR.
            3.  Comments `atlantis apply` on the PR.
        *   **Atlantis:**
            1.  Receives the webhook.
            2.  Runs `terraform apply`.
            3.  Posts the apply output as a comment.
            4.  The PR is now clear to be merged by the developer.

This exercise will solidify your understanding of how a GitOps workflow for infrastructure provides safety and collaboration for your team.
