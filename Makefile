release: build push

build:
	docker pull traefik:2.8
	docker build -t ghcr.io/eugenmayer/traefik:2.x .

push: tag-docker-hub tag-github push-github push-hub
	echo "done pushing"

push-github:
	docker push ghcr.io/eugenmayer/traefik:2.x
	source ./version && docker push ghcr.io/eugenmayer/traefik:$${VERSION}

push-hub:
	docker push eugenmayer/traefik:2.x
	source ./version && docker push eugenmayer/traefik:$${VERSION}

tag-docker-hub:
	source ./version && docker tag ghcr.io/eugenmayer/traefik:2.x eugenmayer/traefik:2.x
	source ./version && docker tag eugenmayer/traefik:2.x eugenmayer/traefik:"$${VERSION}"

tag-github:
	source ./version && docker tag ghcr.io/eugenmayer/traefik:2.x ghcr.io/eugenmayer/traefik:"$${VERSION}"

