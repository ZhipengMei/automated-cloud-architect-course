# Module 1, Week 3: The Unit of Deployment - Containerization with Docker

Welcome to Week 3. We have our code in Git, but how do we run it reliably on any machine? The answer is containerization. Containers are the fundamental unit of deployment in modern cloud architecture.

---

## Session 1: The Problem - "It Works on My Machine!"

Before containers, developers would install dependencies (libraries, runtimes, etc.) directly onto their operating system. This created endless problems:

*   **Environment Drift:** The developer's machine, the testing server, and the production server all had slightly different configurations, leading to bugs that were impossible to reproduce.
*   **Dependency Hell:** Different applications on the same server might require conflicting versions of the same library.
*   **Complex Deployments:** Deploying an application required a long, error-prone checklist of installation steps.

**Containers solve these problems by packaging an application with ALL of its dependencies—libraries, configuration files, and the runtime—into a single, isolated, and portable unit.**

---

## Session 2: The Docker Ecosystem

Docker is the most popular platform for building and running containers.

*   **The Dockerfile:** A simple text file that contains the step-by-step instructions for building a container image. It's like a recipe for your application's environment.
*   **The Docker Image:** The result of building a Dockerfile. It is a read-only template, a snapshot containing your application and its entire environment. You can store images in a registry to be shared.
*   **The Docker Container:** A running instance of a Docker image. It is a lightweight, isolated process running on the host machine's kernel. You can start, stop, and delete containers without affecting the underlying image.
*   **The Docker Engine:** The background service (daemon) that manages and runs Docker containers.

---

## Session 3: Building Your First Image

The process is straightforward:

1.  **Write a `Dockerfile`:** You define a base image, copy your code into it, install dependencies, and specify the command to run when the container starts.
2.  **Run `docker build`:** The Docker Engine executes the steps in your Dockerfile, creating a new image layer for each instruction.
3.  **Run `docker run`:** The Docker Engine creates and starts a new container based on the image you just built.

This process guarantees that the environment you build locally is the *exact* same environment that will run in testing and production.

---

## Lab 3: Containerize the "Hello, World!" Application

**Objective:** To package the application we created last week into a portable Docker container.

**Prerequisites:** You must have Docker Desktop installed on your machine.

**Your Task:**

1.  **Create a `Dockerfile`:**
    *   In the root of your `automated-cloud-architect-course` repository, create a new file named `Dockerfile` (no extension).
    *   Add the following content. Choose the one that matches the language you used for `app.py` or `index.js`.

    **For Python (`app.py`):**
    ```dockerfile
    # Use an official Python runtime as a parent image
    FROM python:3.9-slim

    # Set the working directory in the container
    WORKDIR /app

    # Copy the current directory contents into the container at /app
    COPY . /app

    # Run app.py when the container launches
    CMD ["python", "./app.py"]
    ```

    **For Node.js (`index.js`):**
    ```dockerfile
    # Use an official Node.js runtime as a parent image
    FROM node:16-alpine

    # Set the working directory in the container
    WORKDIR /usr/src/app

    # Copy the current directory contents into the container
    COPY . .

    # Run index.js when the container launches
    CMD ["node", "./index.js"]
    ```

2.  **Build the Docker Image:**
    *   Open a terminal in the root of your repository.
    *   Run the build command. We will "tag" our image with a name (`-t`):
        ```bash
        docker build -t hello-world-app .
        ```
    *   The `.` at the end tells Docker to use the current directory as the build context.

3.  **Run the Docker Container:**
    *   Now, run the container from the image you just built:
        ```bash
        docker run --rm hello-world-app
        ```
    *   The `--rm` flag automatically removes the container when it exits.
    *   You should see "Hello, World!" printed to your terminal.

You have now successfully containerized your application, making it portable and solving the "it works on my machine" problem forever.
