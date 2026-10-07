SRC_DIR := src
OUT_DIR := out
SOURCES := $(wildcard $(SRC_DIR)/*.txt)
OUTPUTS := $(patsubst $(SRC_DIR)/%.txt,$(OUT_DIR)/%.txt,$(SOURCES))

.PHONY: ci check build test clean

ci: clean check build test

check:
	@echo "check: $(words $(SOURCES)) source file(s) in $(SRC_DIR)"

build: $(OUTPUTS)

$(OUT_DIR)/%.txt: $(SRC_DIR)/%.txt
	@mkdir -p $(OUT_DIR)
	@echo " BUILD $< -> $@"
	@tr '[:lower:]' '[:upper:]' < "$<" > "$@"

test: build
	@for f in $(OUTPUTS); do test -s "$$f" || exit 1; done
	@echo "TEST PASSED"

clean:
	rm -rf $(OUT_DIR)

count: build ## count files in source directory
	@find $(SRC_DIR) -maxdepth 1 -name '*.txt' | wc -l
