SH_SRC := $(shell find . -type f -name '*.sh')
DOCKERFILE_SRC := $(shell find . -type f -name 'Dockerfile*'  -o -name 'Dockerfile.*')
CHECK_TOOLS = shellcheck hadolint shfmt

IMAGE := $${IMAGE_NAME:-fnichol/check-shell}

build: ## Builds Docker image
	@echo "--- $@"
	./build.sh $(IMAGE) $${CIRRUS_TAG:-$${TAG:-dev}} latest
.PHONY: build

prepush: check ## Runs all checks/test required before pushing
	@echo "--- $@"
	@echo "all prepush targets passed, okay to push."
.PHONY: prepush

check: check-tools shellcheck shfmt hadolint ## Checks all linting, styling, & other rules
.PHONY: check

shellcheck: ## Checks shell scripts for linting rules
	@echo "--- $@"
	shellcheck --external-sources $(SH_SRC)
.PHONY: shellcheck

shfmt: ## Checks shell scripts for consistent formatting
	@echo "--- $@"
	shfmt -i 2 -ci -bn -d -l $(SH_SRC)
.PHONY: shfmt

hadolint: ## Checks Dockerfiles for linting rules
	@echo "--- $@"
	hadolint $(DOCKERFILE_SRC)
.PHONY: hadolint

check-tools:
	@echo "--- $@"
	$(foreach tool, $(CHECK_TOOLS), $(if $(shell which $(tool)),, \
		$(error "Required tool '$(tool)' not found on PATH")))
.PHONY: check-tools

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

help: ## Prints help information
	@printf -- "\033[1;36;40mmake %s\033[0m\n" "$@"
	@echo
	@echo "USAGE:"
	@echo "    make [TARGET]"
	@echo
	@echo "TARGETS:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk '\
		BEGIN {FS = ":.*?## "}; \
		{printf "    \033[1;36;40m%-12s\033[0m %s\n", $$1, $$2}'
.PHONY: help
