# docker-check-shell

[![Build Status][build-badge]][build] [![Docker Pulls][docker-badge]][docker]
[![GitHub][github-badge]][github]

A Docker image with linters (such as [ShellCheck][] and [hadolint][]) and
formatters (such as [shfmt][]) for POSIX, Bash, and mksh shell code.

**Table of Contents**

<!-- toc -->

- [Getting the Image](#getting-the-image)
- [Usage](#usage)
- [Tools](#tools)
  * [ShellCheck](#shellcheck)
  * [shfmt](#shfmt)
  * [Haskell Dockerfile Linter ("hadolint")](#haskell-dockerfile-linter-hadolint)
- [Issues](#issues)
- [Contributing](#contributing)
- [Authors](#authors)
- [License](#license)

<!-- tocstop -->

## Getting the Image

The image is hosted on Docker Hub and can be pulled down with:

```console
$ docker pull fnichol/check-shell
```

## Usage

This image is intended to be used primarily by CI systems or by developers who
want these tools available on their workstation without explicitly installing
them. As such, there is no entrypoint script and the default `CMD` is `/bin/sh`.

To use this image in a CI system such as [Cirrus CI][cirrus], it is recommended
that you use the `:latest` tag to track the latest published version. For
example, in a `.cirrus.yml` file:

```yaml
container:
  image: fnichol/check-shell:latest

check_task:
  check_script: find . -type f -name '*.sh' | xargs shellcheck
```

In a similar vein, you can use this image on your workstation with a locally
running Docker Engine by mounting your current project directory into the
container and running a tool such as [shfmt][] like so:

```console
$ docker run --rm -v "$(pwd):/src:ro" -w /src fnichol/check-shell \
    shfmt -i 2 -ci -bn -d -l build.sh
```

## Tools

There are several shell linting tools installed into this image--the specific
versions can be determined by inspecting the [Dockerfile][].

### ShellCheck

[ShellCheck][] is a static analysis tool for shell scripts. The installed binary
is taken from the [official][shellcheck-image] Docker image which is statically
linked and the software is released under the [GNU General Public License,
v3][shellcheck-license].

### shfmt

[shfmt][] is a subproject `sh` which is a shell parser, formatter, and
interpreter. The `shfmt` tool focuses formatting [POSIX Shell][posix-shell],
[Bash][], and [mksh][]. The installed binary is taken from the
[official][shfmt-image] Docker image which is statically linked and the software
is released under the [BSD 3-Clause "New" or "Revised" License][shfmt-license]

### Haskell Dockerfile Linter ("hadolint")

The [Haskell Dockerfile Linter][hadolint], usually known as "hadolint", is a
Dockerfile linter that helps you build [best practice][dockerfile-practices]
Docker images. It has understanding of `RUN` instructions and lints their values
as shell code. The installed binary is taken from the [official][hadolint-image]
Docker image which is statically linked and the software is released under the
[GNU General Public License, v3][hadolint-license]

## Issues

If you have any problems with or questions about this image, please contact us
through a [GitHub issue][issues].

## Contributing

You are invited to contribute to new features, fixes, or updates, large or
small; we are always thrilled to receive pull requests, and do our best to
process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub
issue][issues], especially for more ambitious contributions. This gives other
contributors a chance to point you in the right direction, give you feedback on
your design, and help you find out if someone else is working on the same thing.

## Authors

Created and maintained by [Fletcher Nichol][fnichol] (<fnichol@nichol.ca>).

## License

This Docker image is licensed under the [MIT][license] license.

[bash]: https://www.gnu.org/software/bash/
[build-badge]: https://api.cirrus-ci.com/github/fnichol/docker-check-shell.svg
[build]: https://cirrus-ci.com/github/fnichol/docker-check-shell
[cirrus]: https://cirrus-ci.org/
[docker-badge]: https://img.shields.io/docker/pulls/fnichol/check-shell.svg
[docker]: https://hub.docker.com/r/fnichol/check-shell
[dockerfile-practices]:
  https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices
[dockerfile]:
  https://github.com/fnichol/docker-check-shell/blob/master/Dockerfile
[fnichol]: https://github.com/fnichol
[github-badge]:
  https://img.shields.io/github/tag-date/fnichol/docker-check-shell.svg
[github]: https://github.com/fnichol/docker-check-shell
[hadolint-image]: https://hub.docker.com/r/hadolint/hadolint
[hadolint-license]: https://github.com/hadolint/hadolint/blob/master/LICENSE
[hadolint]: https://github.com/hadolint/hadolint
[issues]: https://github.com/fnichol/docker-check-shell/issues
[license]: https://github.com/fnichol/docker-check-shell/blob/master/LICENSE.txt
[mksh]: https://www.mirbsd.org/mksh.htm
[posix-shell]:
  http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html
[shellcheck-image]: https://hub.docker.com/r/koalaman/shellcheck
[shellcheck-license]: https://github.com/koalaman/shellcheck/blob/master/LICENSE
[shellcheck]: https://www.shellcheck.net/
[shfmt-image]: https://hub.docker.com/r/mvdan/shfmt
[shfmt-license]: https://github.com/mvdan/sh/blob/master/LICENSE
[shfmt]: https://github.com/mvdan/sh
