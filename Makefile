release: build push

build:
	docker pull traefik:2.3
	docker pull arm32v6/traefik:2.3
	docker pull arm64v8/traefik:2.3
	docker build -t eugenmayer/traefik:2.x .
	docker build -t eugenmayer/traefik:arm64-2.x . -f Dockerfile_arm64
	docker build -t eugenmayer/traefik:arm32v6-2.x . -f Dockerfile_arm32v6

push:
	source ./version && docker tag eugenmayer/traefik:2.x eugenmayer/traefik:"$${VERSION}"
	source ./version && docker tag eugenmayer/traefik:arm64-2.x eugenmayer/traefik:arm64-"$${VERSION}"
	source ./version && docker tag eugenmayer/traefik:arm32v6-2.x eugenmayer/traefik:arm32v7-2.x
	source ./version && docker tag eugenmayer/traefik:arm32v6-2.x eugenmayer/traefik:arm32v6-"$${VERSION}"
	source ./version && docker tag eugenmayer/traefik:arm32v6-2.x eugenmayer/traefik:arm32v7-"$${VERSION}"
	docker push eugenmayer/traefik:2.x
	docker push eugenmayer/traefik:arm64-2.x
	docker push eugenmayer/traefik:arm32v6-2.x
	docker push eugenmayer/traefik:arm32v7-2.x
	source ./version && docker push eugenmayer/traefik:$${VERSION}
	source ./version && docker push eugenmayer/traefik:arm64-"$${VERSION}"
	source ./version && docker push eugenmayer/traefik:arm32v6-"$${VERSION}"
	source ./version && docker push eugenmayer/traefik:arm32v7-"$${VERSION}"
