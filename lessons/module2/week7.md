# Module 2, Week 7: The Gatekeeper - Hardening the Pipeline

Welcome to Week 7. Our automated pipeline is becoming powerful, but we can still improve it. This week is about "shifting left" even further and implementing strict quality and security gates that prevent bad code from ever reaching the `main` branch.

We will focus on two key mechanisms: local pre-commit hooks and GitHub branch protection rules.

---

## Session 1: The First Line of Defense - Pre-Commit Hooks

So far, our checks run on the CI server *after* code has been pushed. What if we could catch issues *before* the code is even committed? That's the purpose of **pre-commit hooks**.

A pre-commit hook is a script that runs locally on a developer's machine right before a commit is finalized. If the script fails, the commit is aborted.

*   **Why is this powerful?** It provides instant feedback to the developer, catching simple mistakes like formatting errors, syntax issues, or even accidentally committing a secret key, without ever consuming CI resources.
*   **The `pre-commit` Framework:** Managing these hooks can be tricky, so we use a fantastic tool called `pre-commit`. It allows you to define a simple YAML file (`.pre-commit-config.yaml`) to manage a set of hooks from various sources.

---

## Session 2: The Ultimate Gatekeeper - Branch Protection Rules

While pre-commit hooks are a great first check, they can be bypassed. The ultimate gatekeeper for your `main` branch is **GitHub's Branch Protection Rules**.

These are rules you configure in your GitHub repository settings that define what conditions must be met before a pull request can be merged into a protected branch (like `main`).

*   **Essential Branch Protection Rules:**
    *   **Require a pull request before merging:** This disables direct pushes to `main`, forcing all changes to go through a formal review process.
    *   **Require status checks to pass before merging:** This is the most critical rule. You can specify that your "Continuous Integration" workflow (and other jobs) *must* complete successfully. If the tests fail or the vulnerability scan finds a critical issue, GitHub will physically block the "Merge" button.
    *   **Require conversation resolution before merging:** Ensures all review comments are addressed.
    *   **Require signed commits:** Enforces that commits come from a verified source.
    *   **Require linear history:** Prevents merge commits, keeping your `main` branch history clean and easy to follow.

---

## Lab 7: Implementing Quality and Security Gates

**Objective:** To protect our `main` branch by implementing local pre-commit hooks and server-side branch protection rules.

**Your Task:**

1.  **Set up the `pre-commit` Framework:**
    *   First, install the tool on your local machine: `pip install pre-commit`.
    *   In the root of your repository, create a file named `.pre-commit-config.yaml`.
    *   Add the following configuration. This includes hooks to trim whitespace, fix end-of-file issues, and check for common syntax errors.
    ```yaml
    repos:
    -   repo: https://github.com/pre-commit/pre-commit-hooks
        rev: v4.3.0
        hooks:
        -   id: trailing-whitespace
        -   id: end-of-file-fixer
        -   id: check-yaml
        -   id: check-added-large-files
    ```
    *   Now, "install" the git hooks: `pre-commit install`.
    *   The next time you `git commit`, these hooks will run automatically. Try adding a file with trailing whitespace to see it in action.

2.  **Configure Branch Protection Rules:**
    *   Go to your repository on GitHub.
    *   Click on **Settings** -> **Branches**.
    *   Under "Branch protection rules," click **Add rule**.
    *   In "Branch name pattern," type `main`.
    *   Enable the following options:
        *   **Require a pull request before merging**
        *   **Require status checks to pass before merging**
            *   In the search box that appears, find and select the `build` job from your "Continuous Integration" workflow.
        *   **Require conversation resolution before merging**
    *   Click **Create**.

3.  **Test the Protection:**
    *   Create a new feature branch.
    *   Make a change that you know will cause the CI pipeline to fail (e.g., introduce a syntax error or a high-severity vulnerability in `requirements.txt`).
    *   Push the branch and open a Pull Request.
    *   Go to the Pull Request page. You will see the status check running and eventually failing.
    *   Observe that the **"Merge pull request" button is red and disabled**, with a message indicating that required status checks have failed.

You have now successfully hardened your pipeline, ensuring that only high-quality, validated, and secure code can ever make it into your main branch.
