build:
	docker pull traefik:1.7-alpine
	docker pull arm64v8/traefik:1.7-alpine
	docker build -t eugenmayer/traefik .
	docker build -t eugenmayer/traefik:arm64 . -f Dockerfile_arm64

push:
	source version && docker tag eugenmayer/traefik eugenmayer/traefik:"$${VERSION}"
	source version && docker tag eugenmayer/traefik:arm64 eugenmayer/traefik:arm64-"$${VERSION}"
	docker push eugenmayer/traefik:latest
	source version && docker push eugenmayer/traefik:$${VERSION}
	source version && docker push eugenmayer/traefik:arm64-"$${VERSION}"