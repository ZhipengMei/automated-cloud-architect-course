# Module 1, Week 4: The Orchestrator - Introduction to Kubernetes (K8s)

Welcome to Week 4. We can now build and run a container, but what happens when we need to run thousands of them? How do we handle networking, scaling, and self-healing? This is where a container orchestrator comes in, and Kubernetes is the undisputed leader.

---

## Session 1: The Problem - Containers at Scale

A single container is easy to manage. A large, distributed application composed of many containerized microservices is not. You will quickly face new challenges:

*   **Scheduling:** Which machine in my cluster should this new container run on?
*   **Service Discovery:** How does my `frontend` container find the IP address of my `backend` container if it could be running on any machine?
*   **Scaling:** How do I easily scale my application from 3 replicas to 10?
*   **Self-Healing:** What happens if a server crashes or a container dies? How do I automatically restart it?
*   **Rolling Updates:** How do I deploy a new version of my application without any downtime?

**Kubernetes solves these problems by providing a powerful API and control plane to automate the deployment, scaling, and management of containerized applications.**

---

## Session 2: The Kubernetes Architecture - A 10,000-Foot View

Kubernetes has a "desired state" model. You tell Kubernetes *what* you want your application to look like (e.g., "I want 3 replicas of my web server running version 1.2"), and Kubernetes works to make the cluster's actual state match your desired state.

*   **The Control Plane (The Brains):**
    *   **API Server:** The central point of interaction. `kubectl`, our command-line tool, talks to the API server.
    *   **etcd:** A highly available key-value store that holds the entire state of the cluster. It's the single source of truth.
    *   **Scheduler:** Decides which node a new Pod should run on based on resource availability.
    *   **Controller Manager:** Runs various "controllers" that watch for changes and work to match the actual state to the desired state.

*   **The Nodes (The Brawn):** These are the worker machines (VMs or physical servers) where your containers actually run.
    *   **Kubelet:** An agent that runs on each node and communicates with the control plane to ensure containers are running as they should be.
    *   **Kube-proxy:** A network proxy that manages network rules on each node, enabling communication between services.

---

## Session 3: Core Kubernetes Objects

You interact with Kubernetes by creating, updating, and deleting "objects." Here are the most fundamental ones:

*   **Pod:** The smallest deployable unit in Kubernetes. A Pod represents a single instance of your application. It's a wrapper around one or more containers, sharing the same network space and storage. **You rarely create Pods directly.**
*   **Deployment:** This is how you describe your desired state for a set of Pods. You tell a Deployment, "I want 3 replicas of my `hello-world-app` container." The Deployment controller will then create and manage the Pods for you. If a Pod dies, the Deployment will automatically create a new one. This is how we achieve self-healing and scaling.
*   **Service:** A Kubernetes Service provides a stable network endpoint (a single, unchanging IP address and DNS name) for a set of Pods. Other applications can talk to the Service, and it will automatically load-balance traffic to the healthy Pods behind it. This solves service discovery.

---

## Lab 4: Deploying Your First Application to Kubernetes

**Objective:** To take our containerized application and run it on a real Kubernetes cluster.

**Prerequisites:** You need a local Kubernetes cluster. The easiest way is to enable it in Docker Desktop. Go to Docker Desktop -> Settings -> Kubernetes -> Enable Kubernetes.

**Your Task:**

1.  **Create a Deployment Manifest:**
    *   In your repository, create a new file named `deployment.yaml`.
    *   This YAML file describes the Deployment object we want to create.
    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: hello-world-deployment
    spec:
      replicas: 3 # We want 3 instances of our app
      selector:
        matchLabels:
          app: hello-world
      template:
        metadata:
          labels:
            app: hello-world
        spec:
          containers:
          - name: hello-world-container
            image: hello-world-app # The image we built last week
            imagePullPolicy: IfNotPresent # Tells K8s to use the local image
    ```

2.  **Apply the Manifest:**
    *   Use `kubectl`, the Kubernetes command-line tool, to send this manifest to the API server.
        ```bash
        kubectl apply -f deployment.yaml
        ```

3.  **Check the Status:**
    *   See if the Deployment was created and if the Pods are running.
        ```bash
        kubectl get deployment
        kubectl get pods
        ```
    *   You should see your `hello-world-deployment` and 3 `hello-world-deployment-xxxxx` pods in a "Running" state.

4.  **View the Logs:**
    *   Pick one of the pod names from the previous command and view its logs.
        ```bash
        kubectl logs <your-pod-name>
        ```
    *   You should see "Hello, World!" printed.

You have now successfully deployed your application to Kubernetes! However, you can't access it from the outside world yet. We'll solve that with Services and Ingress in a later lesson.
