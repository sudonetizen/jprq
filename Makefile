NAME ?= jprq
PKG ?= github.com/azimjohn/$(NAME)
GO_VERSION ?= 1.22.2
GOOS ?= linux
GOARCH ?= amd64
TEMP_DIR := $(shell mktemp -d)
GOFILES = $(shell find . -name \*.go)

.PHONY: fmt
fmt:
	@echo "Verifying gofmt"
	@!(gofmt -l -s -d ${GOFILES} | grep '[a-z]')

	@echo "Verifying goimports"
	@!(go run golang.org/x/tools/cmd/goimports@latest -l -d ${GOFILES} | grep '[a-z]')

.PHONY: verify
verify:
	golangci-lint run --config tools/.golangci.yaml ./...

.PHONY: test
test:
	@echo Vetting
	go vet ./...
	@echo Testing
	go test ./... -skip TestConfig_Load
