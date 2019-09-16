release: build push

build-1.7:
	docker pull traefik:1.7-alpine
	docker pull arm64v8/traefik:1.7-alpine
	docker pull traefik:2.0-alpine
	docker build -t eugenmayer/traefik:1.7 .
	docker build -t eugenmayer/traefik:arm64-1.7 . -f Dockerfile_arm64
	docker build -t eugenmayer/traefik:arm32v6-1.7 . -f Dockerfile_arm32v6

build-2.0:
	docker pull traefik:2.0-alpine
	docker build -t eugenmayer/traefik:2.0 . -f Dockerfile_2.0

push-2.0:
	source ./version && docker tag eugenmayer/traefik eugenmayer/traefik:"$${VERSION_2}"
	source ./version && docker push eugenmayer/traefik:$${VERSION_2}

push-1.7:
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
