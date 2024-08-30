# Organisation setup  {-}

If you wish to develop your own Tercen modules, an initial setup is required

## 1. Create a Docker Hub organisation {-}

* Operators are Docker images.
* The images are built and pushed to Docker Hub through a GitHub Action after each commit and/or tag.
* When the operator is installed in Tercen, the image is pulled from Docker Hub.
* If you don't already have one, you need to __set up an organisation account__ on [Docker Hub](https://hub.docker.com/): https://hub.docker.com/ 

## 2. Choose a Tercen instance to run unit tests {-}

* Regression testing is used for the development process of Tercen modules.
* Those tests consist in Tercen workflows that can be run on a Tercen instance. This instance needs to be specified and a Tercen "test user" needs to be created. This user will be used to
run the tests from the GitHub Action.
* Choose an instance that will be used to run the test. It could be your development instance for example. You will need to use the service URI (e.g. https://tercen.com) in the next step.
* Create a test user. You will need its name and password in the next step.

## 3. Set up your GitHub organisation {-}

* We assume you already have a GitHub organisation in place
* You need to add the GH secrets
    * DOCKERHUB_ORG, DOCKERHUB_USERNAME and DOCKERHUB_PASSWORD
    * TERCEN_TEST_USERNAME and TERCEN_TEST_PASSWORD
    * TERCEN_TEST_URI
    * GITHUB_PAT
* Template and GH Actions
    * Create a template GitHub repository on your own organisation, based on the Tercen one
    * Edit the GitHub workflow files to replace the secrets by your own organisation secrets you just set up

## 4. Tercen instance configuration {-}

If you are using your own Tercen instance, you need to modify the Tercen config file and add your GitHub organisation to the "trusted git" list.

```yaml
tercen.allow.untrusted.git: 'false'
tercen.allow.untrusted.docker: 'false'
tercen.trusted.git:
  - 'https://github.com/tercen/'
  - 'https://github.com/YOUR_GITHUB_ORGANISATION/'
```

You also need to authorise the Docker Hub organisation.

```yaml
# accept any image name starting by tercen or my-trusted-dockerhub-org, ex. my-trusted-dockerhub-org/my-docker-image
tercen.trusted.docker:
  - 'tercen'
  - 'my-trusted-dockerhub-org'
```
