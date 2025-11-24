# **MailU** mail server with **Docker**

**MailU** is a complete **mail server** that you can deploy with **Docker** as containers. This makes it highly **portable** and manageable. **MailU** comes with all features and functionality you can expect from any proven full grade mail server. You can deploy **MailU** on any platform/**OS** that suports Docker containers.

Consider that this deployment guide generally assumes you put the **MailU** instance behind a reverse proxy like **NginX** to handle the **SSL** termination. Also the concept of **routing domain** has been followed to make this guide compatible for multiple mail server deployment strategy under the same organizational identity.

## Setup
- ### **MailU**
	- Clone **repository** on the server: `git clone https://github.com/SKJoy/Docker-MailU.git`
	- #### Copy `.sample.env` file to `.env` and modify accordingly
		- `DOCKER_NETWORK_PREFIX`: Ensure the **Docker network** doesn't conflict with any existing
		- **Hostname** composition
			- `MAILU_HOSTNAME_DOMAIN`: Domain part of the hostname of the mail server like `domain.tld`
			- `MAILU_HOSTNAME_PREFIX`: Subdomain part of the hostname of the mail server like `mail-1`
			- These together form the **hostname** FQDN like `mail-1.domain.tld`
		- ##### Default `administrator` user credential
			- ###### **Email**; usually `admin@internal.system`
				- `MAILU_ADMIN_USER`: **Username** part
				- `MAILU_ADMIN_DOMAIN`: **Domain** part
			- `DEFAULT_PASSWORD`: Default password
		- `MAILU_HOSTNAMES`: Add additional hostnames like prefixed with `mail`, `smtp`, `imap`, `pop`, etc; **SSL** certificate should be available for these hostnames
		- `MAILU_SECRET_KEY`: Unique `16` byte key per deployment
		- `MAILU_API_TOKEN`: Unique `32` byte token to use with `MailU` API
		- `MAILU_SITE_NAME`: Name of the website to show
		- `MAILU_URL`: Full URL to this **MailU** web interface
		- `MAILU_LOGO_URL`: Custom logo URL
		- `MAILU_LOGO_BACKGROUND_COLOR`: Background color the the custom logo
		- `MAILU_TLS_FLAVOR`: Check detail in `.env` file
		- `MAILU_PORT_HTTP`: Should be `80` if exposed to the internet directly without a reverse proxy
		- `MAILU_PORT_HTTPS`: Should be `443` if exposed to the internet directly without a reverse proxy
		- `MAILU_DAILY_MAX_MESSAGE_PER_USER`: Send out threshold
		- `MAILU_RELAY_NETWORK`: Carefully check the `MailU subnet` doesn't fall into any `public IP` range
		- `MAILU_VERSION`: Specific version to install; check official website
		- `MAILU_ROUNDCUBE_PLUGINS`: List of plugins to be available with the `RoundCube` email client
		- `MAILU_SERVICE_IP`: Use `0.0.0.0` to expose email services to internet
		- `MAILU_REAL_IP_FROM`: Addresses to consider as proxy
		- `MAILU_REAL_IP_HEADER`: Detect real IP from this header with proxy
		- ##### `MAILU_RELAY_HOST`: Remote mail server to relay all emails through
			- `MAILU_RELAY_USER`: Remote relay mail server username
			- `MAILU_RELAY_PASSWORD`: Remote relay mail server password
- ### Reverse proxy
	- **SSL** is to be handled by the reverse proxy
	- Forward **HTTP** port to internal `MailU` container
	- #### Detect real IP from origin proxy like **CloudFlare** (optional)
		- **NginX**
			```
			#real_ip_header CF-Connecting-IP;
			real_ip_header X-Forwarded-For;
			```
- Start the Docker project: `docker compose up -d`
- The **MailU** instance should be accessible through the web browser as configureed with reverse proxy or exposed directly

	- **DNS** needs to be configured before the system becomes accessible
	- #### URL
		- `https://webmail-mail-1.domain.tld` (with routing domain)
		- `https://webmail.mydomain.com` (any regular domain)
	- Use default **administrator** user credential as configured in `.env` file

## **SSL** certificate management behind reverse proxy
- ### Use existing certificate
	- Copy **SSL** certificate files to `Volume/MailU/SSL` path; retain the **MailU** recognized file name;
		- Certificate: `cert.pem`
		- Key: `key.pem`
	- #### Automation
		- Copy `Sample-SSL-Copy.sh` file to `SSL-Copy.sh`
		- Customize `SSL_SOURCE_PATH`, `SSL_SOURCE_CERTIFICATE_FILE` and `SSL_SOURCE_KEY_FILE` values
		- Execute shell script: `bash SSL-Copy.sh`; possibly with a daily **CronJob**
- ### Generate self signed

	- **SSL** certificate should be generated for the first **hostname** with the additional hostnames as **ASN**

	- Execute shell script: `bash SSL-Generate-Self-signed.sh`; it should have a validity of 3650 days!

- Execute shell script: `bash SSL-Generate-Self-signed-or-Copy.sh` if unsure of the external **SSL** certificate existence so a **self signed** certificate is always available; possibly with a daily **CronJob** `0 0 * * * bash /Path/To/MailU/SSL-Generate-Self-signed-or-Copy.sh`
- Restart container: `docker compose restart front` (using any of the above utility shell sctips restarts the container automatically)

## Task
- Clear log file: `bash Log-Clear.sh`; possibly with a monthly **CronJob**
- Clean up everything (doesn't remove any mail server data): `bash Clean.sh`; possibly with a monthly **CronJob**
- Backup: `bash Backup.sh`; Backup file should be available inside the `Backup` folder
- ### Restore
	- Ensure there is no other file or folder in the restore path `/path/to/mailu` (`Backup` folder may exist)
	- Extract backup file: `unzip /path/to/backup.zip -d /path/to/mailu`
	- Fix file permission & start **MailU**: `bash Fix-File-permission.sh` (this will also automatically start the **MailU** instance)
- ### Command line utility
	**MailU Web API** must be **enabled** for these to work.

	**Utility** shell scripts are located within the `CLI-API` folder. Execute the shell scripts without parameters for detailed **sysntax** instruction.

	- Domain
		- Create new: `bash Domain-create.sh new-domain.tld ALLOW_SIGNUP COMMENT` (also creates corresponding DKIM keys)
		- Delete existing: `bash Domain-delete.sh existing-domain.tld`
	- Email account
		- Create new: `bash User-create.sh domain.tld user PASSWORD QUOTA_BYTES COMMENT FORWARD_EMAIL SPAM_DETECTION DISPLAY_NAME` (also creates the domain `domain.tld` if does not exist)
		- Delete existing: `bash User-delete.sh user@domain.tld`

## Caution
- Usual Docker network **subnet** `172.0.0.0/8` may result into an **open relay**
- `SSO`/`Identity server` configuration (**Keycloak**, **Authentik**, etc) is cumbersome due to lack of built in support (needs to be configured through **HTTP** reverse proxy)
- Use mail server **hostname** (`mail-1.domain.tld`) instead of `mail.domain.tld` if SSL connection fails for mail services (IMAP, POP & SMTP)

## **DNS** configuration
- ### Routing domain: `domain.tld`
	- Basic
		- Type: `A`; Name: `mail-1`; Value: **Host public IP**; Proxy: `No`
		- Type: `CNAME`; Name: `webmail-mail-1`; Value: `mail-1.domain.tld`; Proxy: `Yes`
	- Additionally all the **DNS** records applicable for regular domain
- ### Regular domain: `mydomain.com`
	- Basic
		- Type: `CNAME`; Name: `mail`; Value: `mail-1.domain.tld`; Proxy: `No`
		- Type: `CNAME`; Name: `webmail`; Value: `mail.mydomain.com`; Proxy: `Yes`
		- Type: `MX`; Name: `@`; Value: `mail.mydomain.com` (for incoming email)
	- Security
		- Type: `TXT`; Name: `@`; Value: `v=spf1 +mx +a -all` (tightest)
		- Type: `TXT`; Name: `default._domainkey`; Value: `v=DKIM1; k=rsa; p=[DKIM PUBLIC KEY];` (Get this key from within the **MailU** admin panel)
		- Type: `TXT`; Name: `_dmarc`; Value: `v=DMARC1; p=reject;` (tightest)
	- **Email client** automatic configuration
		- Type: `CNAME`; Name: `imap`; Value: `mail.mydomain.com`; Proxy: `No`
		- Type: `CNAME`; Name: `pop`; Value: `mail.mydomain.com`; Proxy: `No`
		- Type: `CNAME`; Name: `smtp`; Value: `mail.mydomain.com`; Proxy: `No`
		- Type: `CNAME`; Name: `autoconfig`; Value: `mail.mydomain.com`; Proxy: `Yes`
		- Type: `CNAME`; Name: `autodiscover`; Value: `autoconfig.mydomain.com`; Proxy: `Yes`

## Email client configuration

- ### Host
	- `mail.mydomain.com` (ignore **SSL** verification with ports)
	- `mail-1.domain.tld` (for explicit secure connection)
- ### Port
	- **IMAP**: Secure: `993` with `SSL`; Insecure: `143`
	- **POP**: Secure: `995` with `SSL`; Insecure: `110`
	- **SMTP**: Secure: `465` with `SSL`; Secure: `587` with `TLS`; Insecure: `25`

- **Password**: As defined when created the user in **MailU** system
- **User**: Full email address like `myname@mydomain.com`

- ### Webmail
	- `https://webmail.mydomain.com`
	- `https://webmail-mail-1.domain.tld`

## **How to** check functionality
- Check for **DNS** configuration with [**MX ToolBox**](https://mxtoolbox.com/)
- Check for **deliverability** with [**Mail Tester**](https://www.mail-tester.com)
- Check **SSL**/**TLS** connection [**CheckTLS**](https://www.checktls.com/TestReceiver)
- Send test email to `check-auth2@verifier.port25.com` and `ping@tools.mxtoolbox.com` addresses and wait for reply with **configuration** check

## Documentation
- ### **MailU**
	- [Official website](https://mailu.io)
	- [Repository](https://github.com/Mailu/Mailu)
	- [Configuration reference](https://mailu.io/2024.06/configuration.html)
- Diagnostics
	- [MX ToolBox](https://mxtoolbox.com/): **DNS** configuration checker
	- [Mail Tester](https://www.mail-tester.com): **Deliverability** tester
	- [CheckTLS](https://www.checktls.com/TestReceiver): **SSL**/**TLS** connection verifier
- **Docker**
	- [Install](https://docs.docker.com/engine/install) **Docker** engine

