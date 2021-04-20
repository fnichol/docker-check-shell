#!/usr/bin/env sh
# shellcheck shell=sh disable=SC2039,SC3043

_print_usage() {
  local program="$1"

  echo "$program

    Builds a Docker image with extended metadata

    USAGE:
        $program [FLAGS] [--] <NAME> [<TAG> ..]

    FLAGS:
        -h, --help      Prints help information
        -v, --verbose   Prints verbose output

    ARGS:
        <NAME>    Name for the Docker image
        <TAG>     Tag for the Docker image [default: latest]
    " | sed 's/^ \{1,4\}//g'
}

main() {
  set -eu
  if [ -n "${DEBUG:-}" ]; then set -v; fi
  if [ -n "${TRACE:-}" ]; then set -xv; fi

  local program
  program="$(basename "$0")"

  OPTIND=1
  while getopts "h-:" arg; do
    case "$arg" in
      h)
        _print_usage "$program"
        return 0
        ;;
      -)
        case "$OPTARG" in
          help)
            _print_usage "$program"
            return 0
            ;;
          '')
            # "--" terminates argument processing
            break
            ;;
          *)
            _print_usage "$program" >&2
            fail "invalid argument --$OPTARG"
            ;;
        esac
        ;;
      \?)
        _print_usage_main "$program" >&2
        fail "invalid argument; arg=-$OPTARG"
        ;;
    esac
  done
  shift "$((OPTIND - 1))"

  if [ -z "${1:-}" ]; then
    _print_usage "$program" >&2
    fail "missing <NAME> argument; arg=-$OPTARG"
  fi
  local name="$1"
  shift

  if [ -z "${VERBOSE:-}" ]; then
    VERBOSE=""
  fi

  if [ -n "$*" ]; then
    build "$name" "$@"
  else
    build "$name" "latest"
  fi
}

build() {
  local name="$1"
  shift
  local tag="$1"
  shift

  local revision created t
  revision="$(git show -s --format=%H)"
  created="$(date -u +%FT%TZ)"

  if [ -n "$VERBOSE" ]; then
    set -x
  fi

  docker build \
    --pull \
    --force-rm \
    --build-arg "NAME=$name" \
    --build-arg "VERSION=$tag" \
    --build-arg "REVISION=$revision" \
    --build-arg "CREATED=$created" \
    --tag "$name:$tag" \
    .

  for t in "$@"; do
    docker tag "$name:$tag" "$name:$t"
  done
}

fail() {
  echo "" >&2
  echo "xxx $1" >&2
  echo "" >&2
  return 1
}

main "$@"
