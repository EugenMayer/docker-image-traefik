release: build push

build:
	docker pull traefik:1.7-alpine
	docker pull arm64v8/traefik:1.7-alpine
	docker build -t eugenmayer/traefik .
	docker build -t eugenmayer/traefik:arm64 . -f Dockerfile_arm64
	docker build -t eugenmayer/traefik:arm32v6 . -f Dockerfile_arm32v6

push:
	source ./version && docker tag eugenmayer/traefik eugenmayer/traefik:"$${VERSION}"
	source ./version && docker tag eugenmayer/traefik:arm64 eugenmayer/traefik:arm64-"$${VERSION}"
	source ./version && docker tag eugenmayer/traefik:arm32v6 eugenmayer/traefik:arm32v6-"$${VERSION}"
	source ./version && docker tag eugenmayer/traefik:arm32v6 eugenmayer/traefik:arm32v7-"$${VERSION}"
	source ./version && docker tag eugenmayer/traefik:arm32v6 eugenmayer/traefik:arm32v7
	docker push eugenmayer/traefik:latest
	docker push eugenmayer/traefik:arm32v6
	docker push eugenmayer/traefik:arm32v7
	docker push eugenmayer/traefik:arm64
	source ./version && docker push eugenmayer/traefik:$${VERSION}
	source ./version && docker push eugenmayer/traefik:arm64-"$${VERSION}"
	source ./version && docker push eugenmayer/traefik:arm32v6-"$${VERSION}"
	source ./version && docker push eugenmayer/traefik:arm32v7-"$${VERSION}"
