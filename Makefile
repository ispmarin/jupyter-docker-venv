IMAGE_NAME := jupyter-docker-venv
TOKEN_FILE := jupyter_token
PORT := 8888

.PHONY: all build run clean token

all: build run

build:
        docker build --build-arg JUPYTER_TOKEN=$$(cat $(TOKEN_FILE)) -t $(IMAGE_NAME) .

run:
        docker run -d -p $(PORT):$(PORT) --name jupyter-docker $(IMAGE_NAME)

podman-build: 
		podman build --build-arg JUPYTER_TOKEN=$$(cat $(TOKEN_FILE)) -t $(IMAGE_NAME) .

podman-run:
		podman run -d -p $(PORT):$(PORT) --name jupyter-docker $(IMAGE_NAME)

clean:
		docker rm -f jupyter-docker || true
		docker rmi $(IMAGE_NAME) || true

podman-clean:
		podman rm -f jupyter-docker || true
		podman rmi $(IMAGE_NAME) || true

token:
		openssl rand -base64 32 > $(TOKEN_FILE)
		@echo "Token generated and saved to $(TOKEN_FILE)"