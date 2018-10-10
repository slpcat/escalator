.PHONY: build setup test test-race test-vet docker clean distclean

TARGET=escalator
# E.g. set this to -v (I.e. GOCMDOPTS=-v via shell) to get the go command to be verbose
GOCMDOPTS?=
PKG_SOURCES=$(shell find pkg/ -type f -iname '*.go')
CMD_SOURCES=$(shell find cmd/ -type f -iname '*.go')

$(TARGET): vendor $(CMD_SOURCES) $(PKG_SOURCES)
	go build $(GOCMDOPTS) -o $(TARGET) cmd/main.go

build: $(TARGET)

setup: vendor

vendor: Gopkg.lock Gopkg.toml
	dep ensure -vendor-only $(GOCMDOPTS)

test:
	go test ./... -cover

test-race:
	go test ./... -cover -race

test-vet:
	go vet ./...

docker: Dockerfile
	docker build -t atlassian/escalator .

clean:
	rm -f $(TARGET)

distclean: clean
	rm -rf vendor
