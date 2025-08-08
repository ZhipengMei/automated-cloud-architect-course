# Module 2, Week 8: Mid-Term Project - The Complete CI Pipeline

Welcome to Week 8, your mid-term project. This week, we will not introduce new concepts. Instead, we will integrate everything we have learned in Modules 1 and 2 to build a complete, end-to-end Continuous Integration (CI) pipeline.

**The Goal:** To create a workflow that automatically takes our application code and produces a secure, validated, and versioned container image in a container registry, ready for deployment.

---

## Project Objective

Your task is to enhance our `ci.yaml` workflow to create a true CI pipeline. When a pull request is opened to `main`, it should run all our checks. When a commit is merged into `main`, it should do all that *and* publish the final container image to a registry.

We will use the **GitHub Container Registry (GHCR)** for this, as it's seamlessly integrated with GitHub Actions.

---

## Project Steps

This lab is a culmination of the previous weeks' work. You will be modifying your existing `ci.yaml` workflow to add publishing capabilities.

**Your Task:**

1.  **Restructure the CI Workflow:**
    *   We need two jobs:
        1.  `test`: Runs on pull requests to perform all checks.
        2.  `build-and-push`: Runs *only* on merges to the `main` branch. It builds the final image and pushes it to the registry.
    *   Replace the entire content of your `.github/workflows/ci.yaml` with the following structure:

    ```yaml
    name: Continuous Integration and Delivery

    on:
      pull_request:
        branches: [ 'main' ]
      push:
        branches: [ 'main' ]

    jobs:
      test:
        runs-on: ubuntu-latest
        # Run this job only for pull requests
        if: github.event_name == 'pull_request'
        steps:
          - name: Checkout code
            uses: actions/checkout@v3

          - name: Set up Python
            uses: actions/setup-python@v3
            with:
              python-version: '3.9'

          - name: Install dependencies
            run: pip install -r requirements.txt

          # Add steps for linting and unit tests here in a real project

          - name: Build Docker image
            run: docker build -t temp-app:latest .

          - name: Scan image with Trivy
            uses: aquasecurity/trivy-action@master
            with:
              image-ref: 'temp-app:latest'
              format: 'table'
              exit-code: '1'
              ignore-unfixed: true
              severity: 'CRITICAL,HIGH'

      build-and-push:
        runs-on: ubuntu-latest
        # Run this job only on pushes to the main branch
        if: github.event_name == 'push' && github.ref == 'refs/heads/main'
        steps:
          - name: Checkout code
            uses: actions/checkout@v3

          - name: Log in to GitHub Container Registry
            uses: docker/login-action@v2
            with:
              registry: ghcr.io
              username: ${{ github.actor }}
              password: ${{ secrets.GITHUB_TOKEN }}

          - name: Build and push Docker image
            uses: docker/build-push-action@v3
            with:
              context: .
              push: true
              tags: ghcr.io/${{ github.repository }}:${{ github.sha }}
    ```

2.  **Understand the New `build-and-push` Job:**
    *   **`if: github.event_name == 'push' ...`**: This condition ensures this job *only* runs when a commit is pushed directly to the `main` branch (i.e., after a PR is merged).
    *   **`docker/login-action`**: A pre-built action that securely logs into a container registry. We use the special `secrets.GITHUB_TOKEN` which is automatically available to every workflow.
    *   **`docker/build-push-action`**: A powerful action that combines `docker build` and `docker push`.
    *   **`tags: ghcr.io/${{ github.repository }}:${{ github.sha }}`**: This is the most important part. We are tagging our image with a unique, immutable identifier: the Git commit SHA. This means every single commit to `main` will produce a unique, versioned container image. For example: `ghcr.io/your-username/automated-cloud-architect-course:f2a4b...`

3.  **Commit and Test:**
    *   Commit this change directly to your `main` branch.
    *   Go to the "Actions" tab. You will see the `build-and-push` job run.
    *   After it succeeds, go to your repository's main page on GitHub. On the right-hand side, you will see a "Packages" section. Click on it. You will see the container image you just published!

4.  **Test the PR Flow:**
    *   Create a new feature branch, make a small change, and open a Pull Request.
    *   Go to the "Actions" tab. You will see that *only* the `test` job runs, validating your changes without publishing anything.

You have now successfully built a complete, modern CI pipeline. You have automated the process of validating code and publishing a secure, versioned artifact, setting the stage for Continuous Deployment.
