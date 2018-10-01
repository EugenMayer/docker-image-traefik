[![](https://images.microbadger.com/badges/image/eugenmayer/traefik.svg)](https://microbadger.com/images/eugenmayer/traefik)

## WAT

Implements a ENV-Var based configuratoin for your Traefik server running as a docker-image.
It bases on top of the official stable release of [Traefik](https://hub.docker.com/_/traefik/) and just adds a bootstrap to generate the `traefik.toml` file from your ENV variables you pass to the container.

The image is published under [eugenmayer/traefik](https://hub.docker.com/r/eugenmayer/traefik)
If you happen to use rancher, you find the corresponding catalog in see the catalog [eugenmayer/docker-rancher-extra-catalogs](https://github.com/EugenMayer/docker-rancher-extra-catalogs/tree/master/templates/traefik)


## WAT its not

Even though this image will make it a lot easier bootstrapping and running your traefik server in production with various providers, this is not a beginners-boilerplate.
That said, all your traefik questions go the Forum/Slack and before that, read the [Traefik Documentation](https://docs.traefik.io/). I will not answer "how to do this in Traefik" questions in the issue queue.
Thanks!

**kubernetes**
If you are using k8s you might rather consider using a [configMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) like [this](https://gist.github.com/joejulian/607f0090230d9aa8701155590c22c3e2) to stick with the canonical way.

## Configuration

To get an idea what you can configure using ENV var, see the listing below - the ENV variables should (hopefully) be self explanatory.
In case they are not, check the [configuration template](https://github.com/EugenMayer/docker-image-traefik/blob/master/tiller/templates/traefik.toml.erb) where you can see where they are used and can look those up in the [Traefik Documentation](https://docs.traefik.io/)
**Be aware** - even though the variables are named `env_XXX` in the `traefik.toml.erb` you use them as `XXX` in env - thats a [tiller](https://github.com/markround/tiller) internal
 
For every variable you find in that listing like `TRAEFIK_DOCKER_ENABLE`, you add an en ENV variable to your image

```
docker run -e TRAEFIK_DOCKER_ENABLE=true eugenamyer/traefik
```

```yaml
version: "2"

services: 
  traefik:
    image: eugenmayer/traefik
    environment:
       TRAEFIK_DOCKER_ENABLE: "true"
```

I guess you get the idea.

## Configuration Features

- TLS support
- ACME dns-01 and http-01 support
- Rancher support
- Docker support (also remote swarm + tls)
- File support
- Metrics
- Basic auth
- Trusted IPs
- Admin Backend / TLS

for more just check the [template]()
 
## Build

```
make build
```

### Configuration Options ( ENV vars)

Those are the avaiable env vars and their default. This should **not replace** the official [Traefik Documentation](https://docs.traefik.io/).
Use this as a starting point / what you can do with this configuration, read the docs in any way.

- TRAEFIK_LOG_LEVEL="INFO"								# Log level
- TRAEFIK_DEBUG="false"									# Enable/disable debug mode
- TRAEFIK_INSECURE_SKIP="false"							# Enable/disable InsecureSkipVerify parameter
- TRAEFIK_LOG_FILE="/var/log/traefik.log"}		        # Log file. Redirected to docker stdout.
- TRAEFIK_ACCESS_FILE="/var/log/access.log"}	        # Access file. Redirected to docker stdout.
- TRAEFIK_TRUSTEDIPS=""                                 # Enable [proxyProtocol](https://docs.traefik.io/configuration/entrypoints/#proxyprotocol) and [forwardHeaders](https://docs.traefik.io/configuration/entrypoints/#forwarded-header) for these IPs (eg: "172.0.0.0/16,192.168.0.1")
- TRAEFIK_USAGE_ENABLE="false"                          # Enable/disable send Traefik [anonymous usage collection](https://docs.traefik.io/basics/#collected-data) 
- TRAEFIK_TIMEOUT_READ="0"                              # respondingTimeouts [readTimeout](https://docs.traefik.io/configuration/commons/#responding-timeouts)
- TRAEFIK_TIMEOUT_WRITE="0"                             # respondingTimeouts [writeTimeout](https://docs.traefik.io/configuration/commons/#responding-timeouts)
- TRAEFIK_TIMEOUT_IDLE="180"                            # respondingTimeouts [idleTimeout](https://docs.traefik.io/configuration/commons/#responding-timeouts)
- TRAEFIK_TIMEOUT_DIAL="30"                             # forwardingTimeouts [dialTimeout](https://docs.traefik.io/configuration/commons/#forwarding-timeouts)
- TRAEFIK_TIMEOUT_HEADER="0"                            # forwardingTimeouts [responseHeaderTimeout](https://docs.traefik.io/configuration/commons/#forwarding-timeouts)

#### Endpoint HTTP
- TRAEFIK_HTTP_PORT=8080								# http port > 1024 due to run as non privileged user
- TRAEFIK_HTTP_COMPRESSION="true"                       # Enable http compression

#### Endpoint HTTPS /TLS
- TRAEFIK_HTTPS_ENABLE="false"							# "true" enables https and http endpoints. "Only" enables https endpoints and redirect http to https.
- TRAEFIK_HTTPS_PORT=8443								# https port > 1024 due to run as non privileged user
- TRAEFIK_HTTPS_MIN_TLS="VersionTLS12"					# Minimal allowed tls version to accept connections from
- TRAEFIK_HTTPS_COMPRESSION="true"                      # Enable https compression

#### Endpoint Admin
- TRAEFIK_ADMIN_ENABLE="false"                          # "true" enables api, rest, ping and webui
- TRAEFIK_ADMIN_PORT=8000								# admin port > 1024 due to run as non privileged user
- TRAEFIK_ADMIN_SSL=false								# "true" enables https on api, rest, ping and webui using  `TRAEFIK_SSL_CRT` certificate
- TRAEFIK_ADMIN_SSL_KEY_FILE="/mnt/certs/ssl.key"       # Default admin backend key file - cert will be auto-generated. Use /mnt/certs/custom.key and put it on the volume to have your own
- TRAEFIK_ADMIN_SSL_CRT_FILE="/mnt/certs/ssl.cert"      # Default admin backend crt file - cert will be auto-generated. Use /mnt/certs/custom.cert and put it on the volume to have your own
- TRAEFIK_ADMIN_STATISTICS=10                           # Enable more detailed statistics
- TRAEFIK_ADMIN_AUTH_METHOD="basic"                     # Auth method to use on api, rest, ping and webui. basic | digest
- TRAEFIK_ADMIN_AUTH_USERS=""                           # Basic or digest users created with htpasswd or htdigest. 

#### ACME
For configuring your endpoints with SSL Certificates, ACME is one of the power features of [Traefik](https://traefik.io)

- TRAEFIK_ACME_ENABLE="false"							# Enable/disable traefik ACME feature. [acme](https://docs.traefik.io/configuration/acme/)
- TRAEFIK_ACME_CHALLENGE="http"                         # Set http | dns to activate traefik acme challenge mode. 
- TRAEFIK_ACME_CHALLENGE_HTTP_ENTRYPOINT="http"         # Set traefik acme http challenge entrypoint. [acme http challenge](https://docs.traefik.io/configuration/acme/#acmehttpchallenge)
- TRAEFIK_ACME_CHALLENGE_DNS_PROVIDER=""                # Set traefik acme dns challenge provider. You need to manually add configuration env variables accordingly the dns provider you use. [acme dns provider](https://docs.traefik.io/configuration/acme/#provider)
- TRAEFIK_ACME_CHALLENGE_DNS_CREDENTIALS=""             # Set you credentials needed for your DNS provider. Use a `key1=value1;key2=value2` syntax, e.g. for Cloudflare `CF_MAIL=aasdas@gmx.de;CF_API=adqweq121` - see [the traefik documentation](https://docs.traefik.io/configuration/acme/#provider) for the avaiable keys
- TRAEFIK_ACME_CHALLENGE_DNS_DELAY=""                   # Set traefik acme dns challenge delayBeforeCheck. [acme dns challenge](https://docs.traefik.io/configuration/acme/#acmednschallenge)
- TRAEFIK_ACME_EMAIL="test@traefik.io"					# Default email
- TRAEFIK_ACME_ONHOSTRULE="true"						# ACME OnHostRule parameter
- TRAEFIK_ACME_CASERVER="https://acme-v02.api.letsencrypt.org/directory"						# ACME caServer parameter
- TRAEFIK_ACME_LOGGING="false"                          # enable debug logging for ACME operations. Useful if you look for ACME issues

#### Provider: File backend
- TRAEFIK_FILE_ENABLE="false"							# Enable/disable file backend
- TRAEFIK_FILE_NAME="/mnt/filestorage/rules.toml"       # where your custom rules will be located. keep that path, its a volume

#### Provider: Kubernetes
- TRAEFIK_K8S_ENABLE="false"							# Enable/disable traefik K8S integration
- TRAEFIK_CONSTRAINTS=""                                # Traefik constraint param. EG: \\"tag==api\\" - see https://docs.traefik.io/configuration/commons/#constraints

#### Provider: Rancher
- TRAEFIK_RANCHER_ENABLE="false"						# Enable/disable traefik RANCHER integration
- TRAEFIK_RANCHER_REFRESH=15                            # Rancher poll refresh seconds
- TRAEFIK_RANCHER_MODE="api"                            # Rancher integration mode. api | metadata
- TRAEFIK_RANCHER_DOMAIN="rancher.internal"				# Rancher domain
- TRAEFIK_RANCHER_EXPOSED="false"						# Rancher ExposedByDefault
- TRAEFIK_RANCHER_HEALTHCHECK="false"					# Rancher EnableServiceHealthFilter
- TRAEFIK_RANCHER_INTERVALPOLL="false"                  # Rancher enable/disable intervalpoll
- TRAEFIK_RANCHER_PREFIX="/2016-07-29"                  # Rancher metadata prefix
- TRAEFIK_RANCHER_CATTLE_URL=""							# Rancher API url
- TRAEFIK_RANCHER_CATTLE_ACCESS_KEY=""					# Rancher access key
- TRAEFIK_RANCHER_CATTLE_SECRET_KEY=""					# Rancher secret key
- TRAEFIK_CONSTRAINTS=""                                # Traefik constraint param. EG: \\"tag==api\\" - see https://docs.traefik.io/configuration/commons/#constraints

#### Provider: Docker
- TRAEFIK_DOCKER_ENABLE="false"                         # use true to enable the [docker provder](https://docs.traefik.io/configuration/backends/docker/)
- TRAEFIK_DOCKER_ENDPOINT="unix:///var/run/docker.sock" # how to access your docker engine - mount this socket or define a `tcp://` based connection
- TRAEFIK_DOCKER_DOMAIN="docker.localhost"              # the default domain to generate frontends for
- TRAEFIK_DOCKER_EXPOSEDBYDEFAULT="true"                # should all docker-containers in the engine be parsed by their exposed ports
- TRAEFIK_DOCKER_SWARMMODE="false"                      # use `tcp://` for accessing a swarm cluster. If you set this, put your TLS creds under `/mnt/certs/docker.ca.crt, /mnt/certs/docker.crt, /mnt/certs/docker.ca.key`
- TRAEFIK_DOCKER_SKIP_VERIFY="false"                    # when set, the connection to the upstream swarm cluster is not verified ( TLS )
- TRAEFIK_CONSTRAINTS=""                                # Traefik constraint param. EG: \\"tag==api\\" - see https://docs.traefik.io/configuration/commons/#constraints

#### Metrics
- TRAEFIK_METRICS_ENABLE="false"                        # Enable/disable traefik [metrics](https://docs.traefik.io/configuration/metrics/)  
- TRAEFIK_METRICS_EXPORTER=""                           # Metrics exporter prometheus | datadog | statsd | influxdb 
- TRAEFIK_METRICS_PUSH="10"                             # Metrics exporter push interval (s). datadog | statsd | influxdb
- TRAEFIK_METRICS_ADDRESS=""                            # Metrics exporter address. datadog | statsd | influxdb 
- TRAEFIK_METRICS_PROMETHEUS_BUCKETS="[0.1,0.3,1.2,5.0]"  # Metrics buckets for prometheus

## Examples

### Docker
```bash
docker-compose -f docker-compose-dockerbackend.yml up

wget http://web1.docker-image-traefik.docker.lan
wget http://web2.docker-image-traefik.docker.lan
```

### ACME DNS-01
Please set your `TRAEFIK_ACME_CHALLENGE_DNS_PROVIDER` and `TRAEFIK_ACME_CHALLENGE_DNS_CREDENTIALS` in `.env` and then run

You `.env` file should like like this, for other provider see the [documentation](https://docs.traefik.io/configuration/acme/#provider)

```dotenv
YOUR_DOMAIN=company.com
TRAEFIK_ACME_CHALLENGE_DNS_PROVIDER=cloudflare
TRAEFIK_ACME_CHALLENGE_DNS_CREDENTIALS=CLOUDFLARE_EMAIL=aasdas@gmx.de;CLOUDFLARE_API_KEY=adqweq121
```

Then start the stack and wait for about 3 minutes for all certificates to get installed
```
docker-compose -f docker-compose-acmedns.yml up


wget https://web1.docker-image-traefik.company.com
wget https://web2.docker-image-traefik.company.com
wget https://foo.company.com
``` 

## Rancher

See the catalog [eugenmayer/docker-rancher-extra-catalogs](https://github.com/EugenMayer/docker-rancher-extra-catalogs/tree/master/templates/traefik) to run this in rancher. Fully integrated with rancher metadata


## Contributions / Development

Glad to merge what makes sense anytime!

To develop new stuff:
if you need more conifugration or you find something missing, please just create a PR while adding 
 - the section the [template](https://github.com/EugenMayer/docker-image-traefik/blob/master/tiller/templates/traefik.toml.erb) 
 - adding the variable and the default value in the [listing here](https://github.com/EugenMayer/docker-image-traefik/blob/master/tiller/common.yaml#L13)
 - and add it to the `README.md` under Configuration
 
 
Start the container in dev mode:

```bash
docker-compose up
# connect to the container
docker compose exec traefik bash

# no modify whatever you need in tiller/templates/traefik.toml.erb or tiller/common.yaml locally, its mounted into the container
# add your new ENV var with _env on the fly
export TRAEFIK_YOURSTUFF_ENABLE=true
# then run this to regenerate the configuration
tiller -v -d 
# check the result in /etc/traefik/traefik.toml
cat /etc/traefik/traefik.toml
```

## Credits

Obviously most of the credits go to [Traefik](https://traefik.io) - cheer them up.
And Once again to [tiller](https://github.com/markround/tiller) for dealing with the configuration template.