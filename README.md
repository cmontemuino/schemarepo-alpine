Schema-Repo on Apline Linux
===========================
This repository contains an Alpine-based Docker with [schema-repo][schema-repo], published to the public Docker Hub via automated build mechanism.

Several measures have been applied for hardening the security of the resulting image. Please see the [security section](#security).

---
Table of Contents
-----------------

* [Getting Started](#getting-started)
  * [Configuration](#configuration)
  * [Healtcheck](#healtcheck)
* [Security](#security)
* [Dependencies](#dependencies)
* [License](#license)
* [Changelog](#changelog)

---

Getting Started
---------------
The simplest way to use this image is by issuing the following command: `docker run -d -p2876:2876 cmontemuino/schemarepo-alpine:latest`

**Please notice the port configuration in above example.**

### Configuration
The Schema-Repo is configured with an _in-memory_ backend as default. If you need to use something different, then pass the `SCHEMA_REPO_BACKEND`
environment variable. Although not available in the documentation, the following are valid options for backend:
* `in-memory`
* `file-system`
* `zookeeper`

Please refer to the [run.sh bash script in schema-repo project][run-bash-script] for further details.


### Healtcheck
The image comes with a very basic healthcheck, but it is enough to get noticed when the container is not providing the schema-repo RESTful API.

Security
--------
Several measures and good practices have been taken into account to protect the Docker container:
* Container run as an ordinary user instead of root.
* SUID flag is removed from container.

When running the container, it is suggested to harden even more the security, for example:

```bash
docker run -d --name schemarepo -p2876:2876 \
  --cap-drop ALL --read-only \
  --memory 100M \
  cmontemuino/schemarepo-alpine:latest
```

Dependencies
------------
* [java:openjdk-8-jdk-alpine][openjdk-8-alpine]

License
-------
Please be aware this project is licensed under GPLv3 (see [LICENSE file](LICENSE)). This can be done because OpenJDK-Apline (dependency),
is licensed under GPLv2-or-later. Please see [GPLv2 compatibility FAQ][gplv2-compatibility].

Changelog
---------
Please refer to [CHANGELOG.md](CHANGELOG.md) file to get the full the changelog details.

[gplv2-compatibility]: http://www.gnu.org/licenses/gpl-faq.html#AllCompatibility
[openjdk-8-alpine]: https://hub.docker.com/_/openjdk/
[schema-repo]: https://github.com/schema-repo/schema-repo
[run-bash-script]: https://github.com/schema-repo/schema-repo/blob/master/run.sh