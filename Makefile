.PHONY: clean build test

template ?= color

STAGE = build test

default: clean build


$(STAGE):
	./.github/actions/smoke-test/$@.sh $(template)

clean:
	rm -rf /tmp/$(template)
