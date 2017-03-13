MIX_BIN ?= $(shell which mix)

all: build
build: deps
	mkdir -p bin
	$(MIX_BIN) escript.build
	mv braise bin
deps: mix.exs mix.lock
	$(MIX_BIN) deps.get
clean:
	rm -rf ./bin/braise ./_build
samples: build
	./bin/braise --file examples/source/v3/patients.json --output examples/output
	./bin/braise --file examples/source/v3/medication_verification.json --output examples/output
	./bin/braise --file examples/source/v20150918/sponsor_api.json --output examples/output
test: build
	$(MIX_BIN) test --no-start
spec: test
toolchest: build
	cp ./bin/braise ~/src/toolchest/bin
