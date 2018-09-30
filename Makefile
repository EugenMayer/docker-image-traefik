build:
	docker build -t eugenmayer/traefik .

push:
	source .env && docker tag eugenmayer/traefik eugenmayer/traefik:"$${VERSION}"
	docker push eugenmayer/traefik