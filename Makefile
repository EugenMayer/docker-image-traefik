release: build push

build:
	docker pull traefik:1.7-alpine
	docker build -t eugenmayer/traefik:1.7 .

push: push-github
	source ./version && docker tag eugenmayer/traefik:1.7 eugenmayer/traefik:"$${VERSION}"
	docker push eugenmayer/traefik:1.7
	source ./version && docker push eugenmayer/traefik:$${VERSION}

push-github:
	source ./version && docker tag eugenmayer/traefik:1.7 ghcr.io/eugenmayer/traefik:"$${VERSION}"
	source ./version && docker tag eugenmayer/traefik:1.7 ghcr.io/eugenmayer/traefik:1.7
	docker push ghcr.io/eugenmayer/traefik:1.7
	source ./version && docker push ghcr.io/eugenmayer/traefik:$${VERSION}