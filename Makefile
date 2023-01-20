all:

ARCH = arm64 amd64
ARCH_TARGET_MAP = aarch64-linux-gnu x86_64-linux-gnu
BINARY = client server tcpforward
TARGET_SET = build release
TARGET = $(foreach value, $(TARGET_SET), $(addprefix $(value)_, $(BINARY)))
DOCKER_TARGET_SET = $(foreach value, $(TARGET_SET), $(addprefix docker_$(value)_linux_, $(ARCH)))
DOCKER_TARGET = $(foreach value, $(DOCKER_TARGET_SET), $(addprefix $(value)_, $(BINARY)))

$(TARGET_SET): %: $(addprefix %_, $(BINARY))

$(TARGET):
	$(eval BINARY_NAME = $(word 2, $(subst _, , $@)))
	$(eval NAME=$(GOOS)-$(GOARCH)-$(BINARY_NAME))
	$(eval OUTPUT_DIR = $(word 1, $(subst _, , $@)))
	@if [ $(OUTPUT_DIR) = build ]; then \
		$(eval CGO_CXXFLAGS += -O0 -g -ggdb)
		echo go build $(OPTIONS) $(GO_LDFLAGS) -o $(OUTPUT_DIR)/$(NAME)$(EXE) ./cmd/$(BINARY_NAME); \
	else \
		$(eval CGO_CXXFLAGS += -O3)
		echo go build -tags release $(RELEASE_OPTIONS) $(GO_LDFLAGS) -o $(OUTPUT_DIR)/$(NAME)$(EXE) ./cmd/$(BINARY_NAME); \
	fi

$(DOCKER_TARGET_SET): %: $(addprefix %_, $(BINARY))

$(DOCKER_TARGET):
	$(eval GOOS = $(word 3, $(subst _, , $@)))
	$(eval GOARCH = $(word 4, $(subst _, , $@)))
	$(eval TARGET = $(subst $(GOARCH)+, , $(filter $(GOARCH)+%, $(join $(ARCH), $(addprefix +, $(ARCH_TARGET_MAP))))))
	$(eval MAKE_TARGET = $(word 2, $(subst _, , $@))_$(word 5, $(subst _, , $@)))
	@echo docker run -it --rm -v $(shell pwd):/go/src/github.com/isrc-cas/gt -w /go/src/github.com/isrc-cas/gt gtbuild:v1 sh -c 'TARGET=$(TARGET) GOOS=$(GOOS) GOARCH=$(GOARCH) make $(MAKE_TARGET)'
