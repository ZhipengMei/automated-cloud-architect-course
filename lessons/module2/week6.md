# Module 2, Week 6: The Secure Artifact - Advanced Docker & Image Security

Welcome to Week 6. Our CI pipeline is running, but our Docker image is inefficient and potentially insecure. A core principle of DevSecOps is to create a **secure artifact**. This means the container image we build should be as small and have as few vulnerabilities as possible.

Today, we'll learn two powerful techniques: multi-stage builds and vulnerability scanning.

---

## Session 1: Optimizing Images with Multi-Stage Builds

Our current `Dockerfile` is simple, but it has a major flaw: it includes the entire Python or Node.js environment, including compilers, build tools, and package managers that are not needed to *run* the application. This bloats the image size and increases its attack surface.

**A multi-stage build solves this.** It uses multiple `FROM` statements in a single `Dockerfile`. You use a full-featured "builder" stage to compile code or install dependencies, and then copy *only the necessary application files* into a clean, minimal "runner" stage.

**Example Concept:**

1.  **Stage 1 (Builder):** Start `FROM` a full OS like `python:3.9`. `COPY` your source code, and `RUN` commands to install dependencies or compile code.
2.  **Stage 2 (Runner):** Start `FROM` a minimal image like `python:3.9-slim` or a distroless image. `COPY --from=0` the compiled code and dependencies from the builder stage.

The final image is *only* the runner stage, which is significantly smaller and more secure.

---

## Session 2: Container Vulnerability Scanning

Every piece of software in your container image, from the base OS to the application libraries you install, is a potential source of security vulnerabilities.

**Container vulnerability scanning** is the automated process of analyzing a container image to find known security issues (CVEs - Common Vulnerabilities and Exposures).

*   **How it Works:** Scanners maintain a database of known vulnerabilities. They inspect the list of software packages in your image and cross-reference them with this database.
*   **When to Scan:** This should be a mandatory step in your CI pipeline. A build should fail if the scanner finds critical vulnerabilities. This is a key "Shift Left" security practice.
*   **Popular Tools:**
    *   **Trivy:** A simple, fast, and very popular open-source scanner.
    *   **Grype:** Another excellent open-source scanner.
    *   **Snyk, Docker Scout:** Commercial tools with advanced features.

---

## Lab 6: Creating a Secure and Optimized Image

**Objective:** To refactor our `Dockerfile` to use a multi-stage build and integrate a vulnerability scanner into our CI pipeline.

**Your Task:**

1.  **Update the `Dockerfile`:**
    *   Replace the content of your `Dockerfile` with the following. This example is for a hypothetical Python app with dependencies, which better illustrates the value.

    ```dockerfile
    # ---- Builder Stage ----
    # Use a full-featured image to install dependencies
    FROM python:3.9-slim as builder

    WORKDIR /app

    # Copy requirements and install them
    COPY requirements.txt .
    RUN pip install --no-cache-dir -r requirements.txt

    # Copy the rest of the application code
    COPY . .

    # ---- Runner Stage ----
    # Use a minimal, secure base image
    FROM python:3.9-slim

    WORKDIR /app

    # Copy the installed dependencies from the builder stage
    COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
    # Copy the application code from the builder stage
    COPY --from=builder /app .

    # Run the application
    CMD ["python", "./app.py"]
    ```
    *   *Note:* For this lab, you'll also need to create a dummy `requirements.txt` file in your repository. It can be empty or contain a library like `requests`.

2.  **Update the CI Workflow (`.github/workflows/ci.yaml`):**
    *   We will add two new steps to our `build` job: one to build the Docker image and one to scan it with Trivy.
    *   Add the following steps to the `jobs.build.steps` section of your `ci.yaml` file, after the "Checkout code" step.

    ```yaml
          # Step to build the Docker image
          - name: Build Docker image
            run: docker build -t hello-world-app:latest .

          # Step to scan the image for vulnerabilities with Trivy
          - name: Scan image with Trivy
            uses: aquasecurity/trivy-action@master
            with:
              image-ref: 'hello-world-app:latest'
              format: 'table'
              exit-code: '1' # Fail the build if vulnerabilities are found
              ignore-unfixed: true
              severity: 'CRITICAL,HIGH'
    ```

3.  **Commit and Push:**
    *   Add the new `requirements.txt` and the changes to your `Dockerfile` and `ci.yaml`.
    *   Commit and push these changes on a new feature branch.

4.  **Observe the Pipeline:**
    *   Open a Pull Request and go to the "Actions" tab.
    *   Watch the workflow run. You will now see the "Build Docker image" and "Scan image with Trivy" steps.
    *   The Trivy step will print a table of any vulnerabilities it finds. Because we set `exit-code: '1'`, the build will fail if it finds any HIGH or CRITICAL severity issues, enforcing our security policy.

You have now created a true DevSecOps pipeline that produces a smaller, more secure, and validated artifact.
