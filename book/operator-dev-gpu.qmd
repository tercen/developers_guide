# GPU Development in Tercen Studio

GPU support is now available in **Tercen Studio**. Follow the steps below to enable and test GPU access in your local setup.

## Setup Instructions

1. **Pull the latest version** of the Tercen Studio repository:  
   [https://github.com/tercen/tercen_studio](https://github.com/tercen/tercen_studio)

2. **Configure Docker for GPU support**. Modify the `docker-compose.yaml` file as described below: 

   a. **Comment out the default runtime-docker image**.

   ```yaml
   #image: docker:24.0.6-dind-alpine3.18
   ```

   b. **Uncomment GPU-related configuration**.

   Under the `dind` service:
   ```yaml
   image: tercen/nvidia-dind:12.1.0-runtime-ubuntu22.04
   deploy:
     resources:
       reservations:
         devices:
           - driver: nvidia
             count: 1
             capabilities: [ gpu ]
   ```
   
   Under the VS Code service `code-server`:
   ```yaml
   deploy:
     resources:
       reservations:
         devices:
           - driver: nvidia
             count: 1
             capabilities: [ gpu ]
   ```

Once the containers are up, you can access the GPU from **Code Server**.

## Changes to operators

- The `Dockerfile` uses a GPU-enabled runtime:

```Dockerfile
FROM tercen/runtime-tf:2.17.0-gpu
```

- The `operator.json` declares GPU capability:

```json
"capabilities": ["gpu"]
```

## Verifying GPU Access

Once inside the container, verify GPU access using TensorFlow or PyTorch.

### TensorFlow
```python
import tensorflow as tf
print("Num GPUs Available:", len(tf.config.list_physical_devices('GPU')))
```

### PyTorch
```python
import torch
print("Is CUDA available:", torch.cuda.is_available())
```

If GPU is not detected, you might need to install some drivers and dependencies on your machine. Please refer to Docker’s GPU support documentation:  
[https://docs.docker.com/desktop/features/gpu/](https://docs.docker.com/desktop/features/gpu/)


