DOCKERFILE_SOURCES := $(shell find . -type f -name 'Dockerfile*'  -o -name 'Dockerfile.*' -not -path './tmp/*' -and -not -path './vendor/*')
CHECK_TOOLS += hadolint

IMAGE := $${IMAGE_NAME:-fnichol/check-shell}

include vendor/mk/base.mk
include vendor/mk/shell.mk

build: ## Builds Docker image
	@echo "--- $@"
	./build.sh $(IMAGE) $${CIRRUS_TAG:-$${TAG:-dev}} latest
.PHONY: build

clean:
.PHONY: clean

check: check-shell hadolint ## Checks all linting, styling, & other rules
.PHONY: check

hadolint: ## Checks Dockerfiles for linting rules
	@echo "--- $@"
	hadolint $(DOCKERFILE_SOURCES)
.PHONY: hadolint

test:
.PHONY: test

tag: ## Create a new release Git tag
	@echo "--- $@"
	version=$$(date -u "+%Y%m%dT%H%M%SZ") \
		&& git tag --annotate "$$version" --message "Release: $$version" \
		&& echo "Release tag '$$version' created." \
		&& echo "To push: \`git push origin $$version\`"
.PHONY: tag

update-toc: ## Update README.md table of contents
	markdown-toc -i README.md
.PHONY: update-toc
