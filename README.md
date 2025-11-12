# **MailU** mail server with **Docker**

## Setup
- ### **MailU**
	- Copy `.sample.env` file to `.env`
	- #### Modify `.env` file accordingly
		- `DOCKER_NETWORK_PREFIX`: Ensure the **Docker network** doesn't conflict with any existing
		- `HOST_NAME`: Mail server `hostname`, an `FQDN`; also responds with **SSL**
		- ##### Default `administrator` credential
			- ###### **Email**; usually `admin@internal.system`
				- `MAILU_ADMIN_USER`: **Username** part
				- `MAILU_ADMIN_DOMAIN`: **Domain** part
			- `DEFAULT_PASSWORD`: Default password
		- `MAILU_HOSTNAMES`: Additional hostnames; usually all the `mail.domain.tld`
		- `MAILU_API_TOKEN`: Unique `32` byte token to use with `MailU` API
		- `MAILU_SITE_NAME`: Name of the website to show
		- `MAILU_SITE_URL`: URL to any website
		- `MAILU_LOGO_URL`: Custom logo URL
		- `MAILU_LOGO_BACKGROUND_COLOR`: Background color the the custom logo
		- `MAILU_TLS_FLAVOR`: Check detail in `.env` file
		- `MAILU_PORT_HTTP`: Should be `80` if exposed to the internet directly without a reverse proxy
		- `MAILU_PORT_HTTPS`: Should be `443` if exposed to the internet directly without a reverse proxy
		- `MAILU_DAILY_MAX_MESSAGE_PER_USER`: Send out threshold
		- `MAILU_RELAY_NETWORK`: Carefully check the `MailU subnet` doesn't fall into any `public IP` range
		- `MAILU_VERSION`: The specific version to install; check official website
		- `MAILU_ROUNDCUBE_PLUGINS`: List of plugins to be available with the `RoundCube` email client
		- `MAILU_SERVICE_IP`: Use `0.0.0.0` to expose services to internet
		- `MAILU_REAL_IP_FROM`: Addresses to consider as proxy
		- `MAILU_REAL_IP_HEADER`: Detect real IP from this header with proxy
		- ##### `MAILU_RELAY_HOST`: Remote mail server to relay all emails through
			- `MAILU_RELAY_USER`: Remote relay mail server username
			- `MAILU_RELAY_PASSWORD`: Remote relay mail server password
- ### Reverse proxy: `NginX`
	- **SSL** is to be handled by the reverse proxy
	- Forward **HTTP** port to internal `MailU` container
	- Configure **HTTP** proxy header to detect real IP for **CloudFlare**
- Start the Docker project: `docker compose up -d`
- **Access**: The **MailU** instance should be accessible through the web browser as configureed with reverse proxy or exposed directly

## **SSL** certificate management behind reverse proxy
- ### Use existing certificate
	- Copy **SSL** certificate files to `Volume/MailU/SSL` path; retain the **MailU** recognized file name;
		- Certificate: `cert.pem`
		- Key: `key.pem`
	- #### Automation
		- Copy `Sample-SSL-Copy.sh` file to `SSL-Copy.sh`
		- Customize `SSL_SOURCE_PATH`, `SSL_SOURCE_CERTIFICATE_FILE` and `SSL_SOURCE_KEY_FILE` values
		- Execute shell script: `bash Sample-SSL-Copy.sh`; possibly with a daily **CronJob**
- ### Generate self signed
	- Copy `Sample-SSL-Generate-Self-signed.sh` file to `SSL-Generate-Self-signed.sh`
	- Customize `HOSTNAME` value
	- Execute shell script: `bash SSL-Generate-Self-signed.sh`; it should have a validity of 3650 days!
- Execute shell script: `bash SSL-Generate-Self-signed-or-Copy.sh`; if unsure of the external SSL certificate existence so a self signed certificate is always available; possibly with a daily **CronJob**
- Restart container: `docker compose restart front`

## Task
- Clear log file: `bash Log-Clear.sh`; possibly with a monthly **CronJob**
- Clean up everything (doesn't remove any mail server data): `bash Clean-up.sh`; possibly with a monthly **CronJob**
- Backup: `bash Backup.sh`; Backup file should be available inside the `Backup` folder
- ### Restore
	- Ensure there is no other file or folder in the restore path `/path/to/mailu` (`Backup` folder may exist)
	- Extract backup file: `unzip /path/to/backup.zip -d /path/to/mailu`
	- Start the Docker stack: `docker compose up -d`

## Caution
- Usual Docker network **subnet** `172.0.0.0/8` may result into an **open relay**

## Documentation
- Official website: `https://mailu.io`
- Repository: `https://github.com/Mailu/Mailu`