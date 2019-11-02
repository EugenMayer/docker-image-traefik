release: build push

build:
	docker pull traefik:1.7-alpine
	docker pull arm64v8/traefik:1.7-alpine
	docker build -t eugenmayer/traefik:1.7 .
	docker build -t eugenmayer/traefik:arm64-1.7 . -f Dockerfile_arm64
	docker build -t eugenmayer/traefik:arm32v6-1.7 . -f Dockerfile_arm32v6

push:
	source ./version && docker tag eugenmayer/traefik:1.7 eugenmayer/traefik:"$${VERSION}"
	source ./version && docker tag eugenmayer/traefik:arm64-1.7 eugenmayer/traefik:arm64-"$${VERSION}"
	source ./version && docker tag eugenmayer/traefik:arm32v6-1.7 eugenmayer/traefik:arm32v6-"$${VERSION}"
	source ./version && docker tag eugenmayer/traefik:arm32v6-1.7 eugenmayer/traefik:arm32v7-"$${VERSION}"
	docker push eugenmayer/traefik:1.7
	docker push eugenmayer/traefik:arm64-1.7
	source ./version && docker push eugenmayer/traefik:$${VERSION}
	source ./version && docker push eugenmayer/traefik:arm64-"$${VERSION}"
	source ./version && docker push eugenmayer/traefik:arm32v6-"$${VERSION}"
	source ./version && docker push eugenmayer/traefik:arm32v7-"$${VERSION}"
