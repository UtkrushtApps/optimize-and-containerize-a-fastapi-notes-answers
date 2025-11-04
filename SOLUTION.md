# Solution Steps

1. 1. Select an optimized Python base image (python:3.11-slim) for minimal size and security surface.

2. 2. Structure the Dockerfile into two stages: a builder stage (for preparing dependencies) and a runtime stage (for final image with only the essentials).

3. 3. In the builder stage, set environment variables to avoid bytecode and for safe output buffers.

4. 4. Install any build dependencies needed for pip/wheels (typically gcc, build-essential) and clean up the apt cache to keep the layer small.

5. 5. Set the WORKDIR to /app for both stages to give a consistent file structure.

6. 6. Copy only requirements.txt early into the builder stage and use pip wheel to pre-build a wheelhouse of all dependencies. This allows Docker to cache this step unless requirements.txt changes.

7. 7. In the runtime stage, copy the wheelhouse and requirements.txt, then pip install from wheels. This is much faster and does not require build tools in the final image.

8. 8. Remove the wheelhouse directory after install to save space.

9. 9. Copy all remaining application code (but keep this as late as possible so dependency layers are cached).

10. 10. Expose the correct port (8000).

11. 11. Use uvicorn as the image's CMD entrypoint.

12. 12. Optimize the .dockerignore file to exclude test/virtualenv/editor/build files and Docker configuration from the context.

13. 13. On rebuild, demonstrate (via Docker logs) that the pip install dependencies step is cached if requirements.txt didn't change.

14. 14. (Optional) Use curl or httpie from the host to verify POST, GET, PUT, DELETE endpoints via the mapped port to ensure the app runs as expected in Docker.

