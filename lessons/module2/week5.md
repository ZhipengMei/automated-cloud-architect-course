# Module 2, Week 5: The Automation Engine - CI with GitHub Actions

Welcome to Module 2. We've covered the foundational pillars: Git, Docker, and Kubernetes. Now, we begin the automation. This module is dedicated to building a Continuous Integration (CI) pipeline. Our goal is to automatically validate, test, and package our code every time a change is pushed to our repository.

Our tool for this is **GitHub Actions**.

---

## Session 1: What is Continuous Integration?

**Continuous Integration (CI)** is a DevOps practice where developers frequently merge their code changes into a central repository, after which automated builds and tests are run.

*   **The Goal:** To detect integration issues as early as possible.
*   **The Core Loop:**
    1.  Developer commits to a feature branch.
    2.  Developer opens a Pull Request to `main`.
    3.  The CI server automatically runs a series of checks (e.g., linting, unit tests).
    4.  If checks pass, the code can be safely merged. If they fail, the developer is notified immediately.

This practice prevents "integration hell," where multiple developers' changes conflict in complex and hard-to-debug ways.

---

## Session 2: Introduction to GitHub Actions

GitHub Actions is a powerful and flexible automation platform built directly into GitHub. It allows you to define custom workflows that respond to events in your repository (like a `push` or `pull_request`).

*   **Workflows:** An automated process defined by a YAML file in the `.github/workflows/` directory of your repository. A repository can have multiple workflows.
*   **Events:** The specific activity that triggers a workflow. Examples: `on: push`, `on: pull_request`, `on: schedule`.
*   **Jobs:** A workflow is made up of one or more jobs, which run in parallel by default. Each job runs in a fresh virtual environment called a **runner**.
*   **Steps:** A job is a sequence of steps. Steps can be shell commands or pre-built **actions**.
*   **Actions:** Reusable units of code that can be shared across the GitHub community. For example, there's an `actions/checkout` action to check out your code and an `actions/setup-node` action to set up a Node.js environment.

---

## Session 3: Building Our First CI Workflow

Let's create a basic CI workflow that runs on every push to a feature branch and every pull request to `main`. It will check out the code and run a simple "Hello" command for now.

This workflow introduces the core concepts in a practical way.

---

## Lab 5: Creating a Basic CI Pipeline

**Objective:** To create a GitHub Actions workflow that automatically runs on code changes.

**Your Task:**

1.  **Create the Workflow Directory:**
    *   In the root of your `automated-cloud-architect-course` repository, create a new directory structure: `.github/workflows/`.
    *   Note the `.` at the beginning of the `.github` directory.

2.  **Create the Workflow File:**
    *   Inside `.github/workflows/`, create a new file named `ci.yaml`.
    *   Add the following content:

    ```yaml
    name: Continuous Integration

    # This workflow runs on pushes to any branch EXCEPT main,
    # and on any pull request to the main branch.
    on:
      push:
        branches-ignore:
          - 'main'
      pull_request:
        branches:
          - 'main'

    jobs:
      build:
        # The type of runner that the job will run on
        runs-on: ubuntu-latest

        steps:
          # Step 1: Check out the code from the repository
          - name: Checkout code
            uses: actions/checkout@v3

          # Step 2: A simple test step
          - name: Say hello
            run: echo "Hello, World! The CI pipeline is running."

          # We will add steps for linting, testing, and building here in future labs.
    ```

3.  **Trigger the Workflow:**
    *   Commit and push this new file to your `main` branch directly for this initial setup.
        ```bash
        git add .github/workflows/ci.yaml
        git commit -m "ci: Add initial CI workflow"
        git push
        ```
    *   Now, create a new feature branch and push a small change (e.g., add a comment to your `app.py` or `index.js` file).
        ```bash
        git checkout -b feature/trigger-ci
        # ...make a small change...
        git add .
        git commit -m "feat: Trigger CI workflow"
        git push -u origin feature/trigger-ci
        ```

4.  **Observe the Action:**
    *   Go to your repository on GitHub and click on the "Actions" tab.
    *   You will see your "Continuous Integration" workflow running. Click on it to see the output of the "Say hello" step.
    *   Now, open a Pull Request from your `feature/trigger-ci` branch to `main`. You will see the action run again on the PR itself.

You have now laid the groundwork for all future automation. This simple workflow will become the backbone of our entire CI/CD pipeline.
