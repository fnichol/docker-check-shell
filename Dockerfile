FROM mvdan/shfmt:v3.3.0 as shfmt
FROM koalaman/shellcheck:v0.7.2 as shellcheck
FROM hadolint/hadolint:2.5.0 as hadolint

FROM alpine:3.12

ARG NAME
ARG VERSION
ARG REVISION
ARG CREATED

ARG SOURCE=https://github.com/fnichol/docker-check-shell.git

LABEL \
  name="$NAME" \
  org.opencontainers.image.version="$VERSION" \
  org.opencontainers.image.authors="Fletcher Nichol <fnichol@nichol.ca>" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="$SOURCE" \
  org.opencontainers.image.revision="$REVISION" \
  org.opencontainers.image.created="$CREATED"

COPY --from=shfmt /bin/shfmt /usr/local/bin/shfmt
COPY --from=shellcheck /bin/shellcheck /usr/local/bin/shellcheck
COPY --from=hadolint /bin/hadolint /usr/local/bin/hadolint

# hadolint ignore=DL3018
RUN apk add --no-cache make \
  && echo "name=$NAME" > /etc/image-metadata \
  && echo "version=$VERSION" >> /etc/image-metadata \
  && echo "source=$SOURCE" >> /etc/image-metadata \
  && echo "revision=$REVISION" >> /etc/image-metadata \
  && echo "created=$CREATED" >> /etc/image-metadata

CMD ["/bin/sh"]
