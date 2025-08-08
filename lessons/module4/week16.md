# Module 4, Week 16: Final Project - The Effortless Application Platform

Welcome to your final project. You have spent 15 weeks learning the principles, tools, and practices of a modern Cloud Architect. You have conceptually built an automated, secure, and observable platform.

This final project is your opportunity to demonstrate your mastery of the entire system by using it to onboard a completely new application with minimal effort.

---

## Project Objective

The true measure of a successful application platform is how easy it is to use. Your goal is to demonstrate that you can deploy a brand-new microservice onto your platform by focusing *only* on the application code and high-level configuration, while the platform handles the rest.

You will be creating a new "Echo Service" and getting it running alongside the "Hello, World!" application.

---

## Project Steps

This project requires you to touch all the different repositories and components we have designed throughout this course.

1.  **Create the New Application:**
    *   Create a new GitHub repository named `echo-service-app`.
    *   Inside, create a simple web application in Python or Node.js. This application should:
        *   Listen on a specific port (e.g., 8080).
        *   Have a single endpoint (e.g., `/echo`) that accepts a POST request.
        *   Whatever JSON body the service receives, it should return it directly as the response.
    *   Add a `Dockerfile` to package this new service.

2.  **Integrate with the CI Pipeline:**
    *   Copy the `.github/workflows/ci.yaml` workflow from your `hello-world-app` into the new `echo-service-app` repository.
    *   This will ensure your new service gets the same automated testing, security scanning, and image publishing capabilities as your first application.

3.  **Update the Helm Chart:**
    *   A good Helm chart is reusable. Go to your `hello-world-chart` repository.
    *   Modify the chart to be more generic. Instead of being hardcoded for "hello-world," it should be able to deploy *any* simple web service.
    *   This might involve changing names in `templates/deployment.yaml` from `hello-world` to `{{ .Release.Name }}`.

4.  **Update the Manifests (GitOps) Repository:**
    *   This is the key step. Go to your `hello-world-manifests` repository.
    *   You will make two changes here:
        1.  **Update the existing application:** In the `values.yaml` for your "Hello, World!" app, point it to the newly improved, generic Helm chart.
        2.  **Add the new application:** Create a new `Application` manifest for the `echo-service`. It will point to the *same* generic Helm chart but will override the values to specify the `echo-service` image repository and tag.

5.  **Declare Victory:**
    *   Once you commit the changes to your manifests repository, your conceptual Argo CD instance would automatically:
        *   Recognize the new `Application` resource for the echo-service.
        *   Deploy the `echo-service` using the generic Helm chart.
        *   Ensure the `hello-world` service is also using the latest generic chart.
    *   You can simulate this by running `helm install echo-release ./path/to/generic-chart --set image.repository=echo-service-app` in your local cluster.

---

## Course Conclusion

Congratulations! By completing this final project, you have demonstrated a holistic understanding of a modern, automated, cloud-native application platform.

You have proven that you can:
*   **Focus on Value:** Onboard a new service by focusing on the application code itself.
*   **Leverage the Platform:** Use the automated CI/CD, IaC, and GitOps pipelines to handle the undifferentiated heavy lifting of security, packaging, and deployment.
*   **Think Like an Architect:** Understand how all the different components (Git, Docker, Kubernetes, Terraform, Helm, Argo CD) work together to create a single, cohesive system.

You are no longer just a user of the cloud; you are an architect of it.
