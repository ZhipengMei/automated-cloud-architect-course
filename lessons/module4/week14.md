# Module 4, Week 14: The Full Loop - End-to-End Automation

Welcome to Week 14. We have assembled all the individual components of our platform. This week, we connect them. The goal is to experience the "magic" of a fully automated platform, where a developer can `git push` a code change and simply watch it go live without any manual intervention.

This lesson is a review and synthesis of the entire system we've designed.

---

## Session 1: Reviewing the System Architecture

Let's revisit the high-level architecture we have conceptually built. It consists of several key components that work in concert:

1.  **Application Code Repository (`hello-world-app`):**
    *   Contains the application source code.
    *   Contains the `Dockerfile` for packaging the app.
    *   Contains the CI pipeline definition (`.github/workflows/ci.yaml`).
    *   **Purpose:** To produce a versioned, secure container image.

2.  **Helm Chart Repository (`hello-world-chart`):**
    *   Contains the reusable Helm chart for deploying the application.
    *   **Purpose:** To define *how* the application runs on Kubernetes.

3.  **Manifest Repository (`hello-world-manifests`):**
    *   This is our GitOps repository.
    *   It contains the Argo CD `Application` manifest.
    *   It contains a `values.yaml` that references a specific image tag from the application repository.
    *   **Purpose:** To declare the *desired state* of our application in the production cluster.

4.  **The Kubernetes Cluster:**
    *   **Argo CD** runs inside the cluster, constantly watching the `hello-world-manifests` repository.
    *   When the `image.tag` in the manifests repo changes, Argo CD pulls the new image and updates the deployment.

---

## Session 2: The Developer Experience

The most important outcome of this entire system is the **developer experience**. In a well-architected platform, the developer should be able to focus almost exclusively on writing application code.

**The Ideal Workflow:**

1.  The developer clones the `hello-world-app` repository.
2.  They create a feature branch.
3.  They write code.
4.  They commit their code. `pre-commit` hooks run locally, catching simple errors.
5.  They push their branch and open a Pull Request.
6.  The CI pipeline runs automatically, running tests and vulnerability scans. Branch protection rules prevent merging if checks fail.
7.  The PR is reviewed and merged to `main`.
8.  A final CI job runs, building a new container image tagged with the commit SHA (e.g., `:f2a4b...`).
9.  An automated process (or the developer) updates the `image.tag` in the `hello-world-manifests` repository.
10. Argo CD detects the change and deploys the new version.

The platform abstracts away the complexity of building, securing, and deploying the application. The developer is empowered to deliver value faster and more safely.

---

## Lab 14: Experiencing the Full Loop

**Objective:** To perform a dry run of the entire, end-to-end workflow, acting as both the developer and the platform.

**Your Task:**

This is a thought experiment to connect all the labs we've done.

1.  **Act as the Developer:**
    *   Go to your local clone of the `hello-world-app` repository.
    *   Create a new branch.
    *   Make a visible change to the application (e.g., change the "Hello, World!" message).
    *   Commit and push the change.

2.  **Act as the CI System:**
    *   Mentally confirm that your CI pipeline (from Week 8) would have run.
    *   Go to your repository's "Actions" tab on GitHub. Find the latest run on the `main` branch.
    *   Find the commit SHA for your latest change. This is your new image tag. For example, `f2a4b1c`.

3.  **Act as the Release Manager:**
    *   Go to your local clone of the `hello-world-manifests` repository (or the `terraform-helm-deploy` repo from Week 12).
    *   Find the line where the image tag is defined.
    *   Change the tag to the new commit SHA you found in the previous step.
    *   Commit and push this change.

4.  **Act as Argo CD:**
    *   Mentally confirm that Argo CD would detect this change.
    *   To simulate the result, go to your local Kubernetes cluster.
    *   Manually run a `helm upgrade` command, pointing to your Helm chart and explicitly setting the new image tag.
        ```bash
        helm upgrade hello-from-terraform ./path/to/hello-world-chart --set image.tag=f2a4b1c
        ```
    *   Check the pods. You will see Kubernetes performing a rolling update, terminating the old pods and starting new ones with the updated code.

By manually walking through these steps, you can see exactly how the different automated components connect to form a seamless, powerful, and effortless application platform.
