# Module 3, Week 11: The Application Blueprint - Packaging with Helm

Welcome to Week 11. We know how to deploy a single Kubernetes object using a YAML file (`deployment.yaml`). But a real application is composed of many objects: a Deployment, a Service, a ConfigMap, an Ingress, etc. Managing all these separate YAML files is cumbersome and error-prone.

We need a way to package all of our application's Kubernetes resources into a single, configurable, and version-controlled unit. This is what **Helm** provides. Helm is the package manager for Kubernetes.

---

## Session 1: The Problem with Raw Kubernetes YAML

Imagine our "Hello, World!" application grows. To run it properly in production, we might need:

*   `deployment.yaml`: To manage the application Pods.
*   `service.yaml`: To expose the Pods internally.
*   `configmap.yaml`: To store application configuration.
*   `ingress.yaml`: To expose the application to the outside world.

Now, what if you want to deploy this same application to a staging environment? You'd have to copy and paste all these files and carefully find-and-replace values like the number of replicas or the domain name. This is not scalable or reliable.

---

## Session 2: Helm to the Rescue

Helm solves this by packaging all of your YAML files into a single unit called a **Chart**.

*   **Chart:** A collection of files that describe a related set of Kubernetes resources. It's the packaging format for Helm.
*   **Templates:** The YAML files inside a chart are turned into templates using the Go template language. This allows you to parameterize your manifests. For example, instead of `replicas: 3`, you would write `replicas: {{ .Values.replicaCount }}`.
*   **Values:** Helm charts have a `values.yaml` file that provides the default values for all the template variables. This is the single place where you define the configuration for your application.
*   **Release:** A `Release` is an instance of a chart running in a Kubernetes cluster. You can install the same chart multiple times into the same cluster, each with a different configuration (e.g., `staging-release` and `production-release`).

---

## Session 3: The Helm Workflow

1.  **Create a Chart:** You run `helm create my-app-chart`. This command scaffolds a new chart directory with all the necessary files and subdirectories.
2.  **Customize the Templates:** You modify the template files (e.g., `templates/deployment.yaml`) to match your application's needs, using variables like `{{ .Values.image.repository }}`.
3.  **Configure `values.yaml`:** You edit the `values.yaml` file to set the default image, tag, replica count, etc.
4.  **Install the Chart:** You run `helm install my-release ./my-app-chart`. Helm renders the templates with the values and applies the resulting YAML to your Kubernetes cluster.
5.  **Upgrade the Chart:** To make a change, you modify your chart (e.g., update the image tag in `values.yaml`) and run `helm upgrade my-release ./my-app-chart`. Helm will intelligently figure out what changed and only apply the necessary updates to the cluster.

---

## Lab 11: Creating Your First Helm Chart

**Objective:** To package our "Hello, World!" application's Kubernetes manifests into a reusable Helm chart.

**Your Task:**

1.  **Install Helm:** Follow the official instructions to install the Helm CLI on your machine.

2.  **Create a new Chart:**
    *   In a suitable directory (this can be inside your `automated-cloud-architect-course` repo), run:
        ```bash
        helm create hello-world-chart
        ```
    *   Explore the generated directory structure, especially `templates/` and `values.yaml`.

3.  **Customize `values.yaml`:**
    *   Open `hello-world-chart/values.yaml`.
    *   Find the `image` section and change the `repository` to `hello-world-app` (the name of the image we built in Week 3). Set the `tag` to `latest`.
    *   This tells the chart what image to deploy.

4.  **Clean up the Templates:**
    *   The default chart creates many objects we don't need yet. For simplicity, delete the files `templates/serviceaccount.yaml`, `templates/ingress.yaml`, and `templates/hpa.yaml`. Also delete their tests in `templates/tests/`.

5.  **Install the Chart (Dry Run):**
    *   A "dry run" will render the templates but not actually apply them. It's a great way to see the final YAML that Helm will generate.
        ```bash
        helm install my-hello-release ./hello-world-chart --dry-run
        ```
    *   Examine the output. You will see a fully-formed `Deployment` and `Service` manifest.

6.  **Install the Chart for Real:**
    *   Make sure your local Kubernetes cluster is running.
    *   Run the install command:
        ```bash
        helm install my-hello-release ./hello-world-chart
        ```

7.  **Verify the Release:**
    *   Check the status of your Helm releases:
        ```bash
        helm list
        ```
    *   Check the Kubernetes objects that were created:
        ```bash
        kubectl get deployment
        kubectl get service
        ```
    *   You should see the `my-hello-release-hello-world-chart` deployment and service.

8.  **Clean Up:**
    *   Uninstall the release:
        ```bash
        helm uninstall my-hello-release
        ```

You have now packaged your application into a reusable, configurable Helm chart, making your Kubernetes deployments far more manageable and professional.
