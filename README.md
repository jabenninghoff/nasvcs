# nasvcs

NAS hosted version control system container with ssh and web access.

The current design assumes a single user, **vcs**, and provides access to git and cvs via SSH using key-based authentication only. Using a non-standard port for SSH will reduce ssh login noise. The container also provides web-based read access to git and cvs via [GitWeb](https://git-scm.com/book/en/v2/Git-on-the-Server-GitWeb) and [ViewVC](https://viewvc.org) respectively, and is intended to be deployed locally (on localhost) or behind a HTTPS reverse proxy with a secure connection to the container, as the web server uses Basic authentication which sends passwords in clear text.

Based on [nasmail](https://github.com/jabenninghoff/nasmail).

## Docker Image

nasvcs uses GitHub Actions to build and publish a Docker image to the GitHub Container Registry, using design, automation, and tests based on nasmail. The included `compose.yaml` file can be adapted to deploy the container using `docker compose`.

Pull the latest (stable) image using:

```sh
docker pull ghcr.io/jabenninghoff/nasvcs
```

New images are published for each new release only; there are no development images (`edge` or `main`). All pull requests and merges to main build and load the image (without publishing) for testing and validation. Images are built for Intel (`amd64`), 64-bit ARM (`arm64`: Apple, Raspberry Pi) and 32-bit ARM (`arm/v6`, `arm/v7`: older Raspberry Pi hardware).

Make sure to update the `image` section of the `compose.yaml`, a complete production file should resemble:

```yaml
services:
  nasvcs:
    image: ghcr.io/jabenninghoff/nasvcs:<version>
    restart: unless-stopped
    hostname: nasvcs.test
    ports:
      - "22:22" # SSH
      - "80:80" # HTTP (use with HTTPS reverse proxy)
    volumes:
      - /full/path/to/hostkeys:/opt/nasvcs/etc/ssh:ro
      - /full/path/to/user:/opt/nasvcs/user:ro
      - /full/path/to/vcs:/opt/nasvcs/vcs
    environment:
      - NASVCS_GIT_PROJECTROOT=/opt/nasvcs/vcs/git
```

## Environment Variables

- `NASVCS_GIT_PROJECTROOT`: path to the GitWeb `$projectroot`, defaults to `/opt/nasvcs/vcs/git`

## User

Login to the ssh server using the vcs account (`ssh vcs@nasvcs.test`), by adding one or more ssh keys to `/opt/nasvcs/user/authorized_keys`. Add a username and password to log in to GitWeb and ViewVC by generating a password using the Docker container and pasting it into `/opt/nasvcs/user/lighttpd.user`, using the commands below:

```sh
docker run --rm -it --entrypoint sh ghcr.io/jabenninghoff/nasvcs:latest
htpasswd -nBC 10 vcs
```

## OpenSSH

nasvcs uses [OpenSSH](https://www.openssh.org) sshd for secure hosting of git and cvs. SSH Host Keys are persisted in the `/opt/nasvcs/etc/ssh` volume, mapped to `hostkeys` in the example Docker Compose file. sshd is configured to only allow SSH key-based authentication, and logins are restricted to only allow the vcs user with the `AuthorizedKeysFile /opt/nasvcs/user/authorized_keys`. root login is explicitly denied. Users must have a password to allow SSH logins, so nasvcs sets a random password for the vcs user at startup.

SSH configuration can be verified using the included `sshd-login.sh`, which tests that vcs login succeeds and all other logins fail.

## CVS

Multiple [CVS](https://www.nongnu.org/cvs/) repository roots can be stored in `/opt/nasvcs/vcs`; the default name is `cvs`. For convenience, all cvs repositories are symlinked in the root directory for easy checkout; `cvs -d vcs@nasvcs.test:/cvs checkout project`.

## git

nasvcs supports a single [git](https://git-scm.com) project root, `/opt/nasvcs/vcs/git` by default. git is also symlinked in the root directory; `git clone vcs@nasvcs.test:/git/project`

## GitWeb

Web access to git is provided using [GitWeb](https://git-scm.com/docs/gitweb) on [lighttpd](https://www.lighttpd.net), and can be viewed at `/gitweb/`; for example, <http://nasvcs.test/gitweb/>. Access to GitWeb is restricted using Basic authentication using a username and password stored in `/opt/nasvcs/user/lighttpd.user`. The git project root can be set using the `NASVCS_GIT_PROJECTROOT` environment variable, which defaults to `/opt/nasvcs/vcs/git`.

## ViewVC

[ViewVC](https://github.com/viewvc/viewvc) provides web access to one or more cvs roots using lighttpd. ViewVC is configured to scan the `/opt/nasvcs/vcs` directory for cvs roots which are viewable at `/viewvc/`; <http://nasvcs.test/viewvc/>. Access to ViewVC is also restricted using Basic authentication using the username and password stored in `/opt/nasvcs/user/lighttpd.user`.

nasvcs makes the following configuration changes to ViewVC:

- By default, ViewVC [omits hyperlinks](https://github.com/viewvc/viewvc/issues/407) for files in its directory listings that have a MIME type other than `text/*`. This behavior is overridden by a patch to the default template that always links files to the "markup" view.
- ViewVC disables some view types as they introduce a security risk on shared systems. nasvcs enables all view types in `viewvc.conf`.

Currently, ViewVC generates errors in the lighttpd logs. Logged as ViewVC issue [#408](https://github.com/viewvc/viewvc/issues/408).

```text
Exception ignored while finalizing file <TextIOWrapper_noclose name='<ServerFile file>' encoding='utf-8'>:
AttributeError: attribute 'closed' of '_io.TextIOWrapper' objects is not writable
```

## lighttpd

lighttpd is a low-resource web server that has a lower memory footprint than Apache or Nginx. It is configured to allow viewing of the git and CVS repositories hosted on the server using the GitWeb and ViewVC CGI scripts. To reduce noise from web crawlers, the root directory (<http://nasvcs.test/>) is empty and does not require authentication, which will return error code 403 (Forbidden). GitWeb and ViewVC are protected using Basic Authentication using lighttpd [mod_auth](https://redmine.lighttpd.net/projects/lighttpd/wiki/mod_auth).

The recommended and [example](https://redmine.lighttpd.net/projects/1/wiki/HowToBasicAuth) configurations use Digest Authentication using [RFC7616](https://datatracker.ietf.org/doc/html/rfc7616) SHA-256; this method is supported by Firefox and Chrome, but not [Safari](https://github.com/WebKit/standards-positions/issues/212) and possibly other browsers. To maximize browser support, nasvcs implements Basic Authentication and must be configured to be accessed through localhost or behind a HTTPS reverse proxy to prevent interception of plain text passwords.

lighttpd appears to support all password hashes provided by Apache [htpasswd](https://httpd.apache.org/docs/current/programs/htpasswd.html), including bcrypt, which was verified to work. The recommended hash is bcrypt (the strongest method) using a computing time parameter of 10: `htpasswd -BC 10 -c lighttpd.user user`, but other hashes should work. htpasswd is installed on the Docker image for convenience.

## runit

nasvcs uses [runit](https://smarden.org/runit/) to manage Postfix and Dovecot as system services.

<!-- # TODO: add Tests section -->
