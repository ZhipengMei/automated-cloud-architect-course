# Module 4, Week 15: The Guardian - Cloud Security Posture Management (CSPM)

Welcome to Week 15. Our platform is fully automated, from code to deployment. But is it secure?

We have "shifted left" to scan our container images for vulnerabilities, which is excellent. But what about the security of the live, running cloud environment itself? Are our S3 buckets public? Are our databases unencrypted? This is where **Cloud Security Posture Management (CSPM)** comes in.

---

## Session 1: Beyond Application Security

DevSecOps focuses heavily on the security of the application artifact (the container image). CSPM focuses on the security of the **cloud infrastructure** the application runs on.

*   **The Problem:** Cloud environments are incredibly complex. A single misconfiguration—a wrong checkbox in the AWS console, a forgotten firewall rule—can expose your entire system. It's impossible for humans to track every setting across hundreds of resources.
*   **The Solution:** CSPM tools continuously scan your cloud account's configuration against a massive database of security best practices and compliance standards (like CIS Benchmarks, SOC 2, HIPAA, etc.).

---

## Session 2: How CSPM Tools Work

Tools like **Orca Security**, Wiz, or Prisma Cloud work by connecting to your cloud provider's API (e.g., AWS, Azure, GCP) with read-only credentials.

They continuously perform a wide range of checks, looking for issues like:

*   **Publicly exposed resources:** S3 buckets, databases, or virtual machines accessible from the internet.
*   **Insecure network configurations:** Firewall rules that are too permissive.
*   **Lack of encryption:** Data at rest (in databases, buckets) or in transit that is not encrypted.
*   **Identity and Access Management (IAM) issues:** Users with excessive permissions.
*   **Vulnerabilities in running virtual machines:** They can even detect vulnerabilities on the host OS, not just in containers.
*   **Compliance violations:** Automatically checking if your configuration meets the requirements for specific industry regulations.

---

## Session 3: Integrating CSPM into the DevOps Loop

CSPM is not just a tool for security teams; it's a critical part of the DevOps feedback loop.

*   **Alerting:** When a CSPM tool detects a high-risk misconfiguration, it should automatically create an alert (e.g., in Slack or PagerDuty) to notify the responsible team.
*   **Closing the Loop:** The true power of CSPM is realized when its findings are used to improve the Infrastructure as Code.
    *   If Orca Security finds a publicly exposed S3 bucket...
    *   ...the team should not fix it in the AWS console.
    *   ...they should fix it in the **Terraform code** that defines the bucket, and then apply the change through their automated Atlantis workflow.

This ensures the fix is permanent and the infrastructure state in Git once again matches the secure state in reality. It turns security findings into actionable, version-controlled code changes.

---

## Lab 15: (Conceptual) Analyzing a CSPM Report

**Objective:** To understand the kind of insights a CSPM tool provides and how to act on them.

**Your Task:**

Imagine you have just received the following simplified report from your CSPM tool for your production AWS account. For each finding, describe:
1.  The immediate risk.
2.  The correct, code-based remediation step.

---

**CSPM Report - High Priority Findings:**

*   **Finding 1: S3 Bucket `my-production-data` has public read access.**
    *   **Risk:**
    *   **Remediation:**

*   **Finding 2: Security Group `sg-12345` allows inbound traffic from `0.0.0.0/0` on port `22` (SSH).**
    *   **Risk:**
    *   **Remediation:**

*   **Finding 3: IAM User `dev-user-1` has the `AdministratorAccess` policy attached.**
    *   **Risk:**
    *   **Remediation:**

---

*(Fill out the Risk and Remediation sections based on what you've learned. This exercise will train you to think like a Cloud Security Architect, translating security alerts into concrete infrastructure code changes.)*
