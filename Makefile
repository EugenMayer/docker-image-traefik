build:
	docker build -t eugenmayer/traefik .

push:
	source version && docker tag eugenmayer/traefik eugenmayer/traefik:"$${VERSION}"
	docker push eugenmayer/traefik