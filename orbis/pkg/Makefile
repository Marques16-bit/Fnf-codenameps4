# ELF (gerado pelo hxcpp) -> eboot.bin -> param.sfo -> pkg.gp4 -> .pkg
# Uso:  make ELF=/caminho/Main.elf   (o scripts/03-build-hello.sh ja chama isso)
TOOLCHAIN := $(OO_PS4_TOOLCHAIN)
OOS       ?= $(if $(OO_OS),$(OO_OS),linux)
BIN       := $(TOOLCHAIN)/bin/$(OOS)

ELF        ?= ../tests/hello/out/Main.elf
TITLE      ?= FNF Orbis Hello
TITLE_ID   ?= FNFO00001
CONTENT_ID ?= IV0000-$(TITLE_ID)_00-FNFORBISHELLO000

STAGE := build/stage
DIST  := dist

# arquivos que vem do proprio toolchain do OpenOrbis
LIBC_PRX   := $(shell find $(TOOLCHAIN) -name libc.prx 2>/dev/null | head -n1)
FIOS_PRX   := $(shell find $(TOOLCHAIN) -name libSceFios2.prx 2>/dev/null | head -n1)
RIGHT_SPRX := $(shell find $(TOOLCHAIN) -name right.sprx 2>/dev/null | head -n1)

SFO := $(BIN)/PkgTool.Core sfo_setentry $(STAGE)/sce_sys/param.sfo

.PHONY: all clean
all: $(DIST)/.done

$(DIST)/.done: $(ELF) sce_sys/icon0.png
	@test -n "$(OO_PS4_TOOLCHAIN)" || (echo "rode: source env.sh"; exit 1)
	@test -n "$(LIBC_PRX)" -a -n "$(FIOS_PRX)" || (echo "libc.prx / libSceFios2.prx nao achados em $(TOOLCHAIN)"; exit 1)
	rm -rf $(STAGE) && mkdir -p $(STAGE)/sce_sys/about $(STAGE)/sce_module $(DIST)
	cp sce_sys/icon0.png $(STAGE)/sce_sys/icon0.png
	cp $(LIBC_PRX) $(FIOS_PRX) $(STAGE)/sce_module/
	@if [ -n "$(RIGHT_SPRX)" ]; then cp $(RIGHT_SPRX) $(STAGE)/sce_sys/about/right.sprx; fi
	$(BIN)/create-fself -in=$(ELF) -out=$(STAGE)/Main.oelf --eboot=$(STAGE)/eboot.bin --paid 0x3800000000000011
	$(BIN)/PkgTool.Core sfo_new $(STAGE)/sce_sys/param.sfo
	$(SFO) APP_TYPE --type Integer --maxsize 4 --value 0
	$(SFO) APP_VER --type Utf8 --maxsize 8 --value "01.00"
	$(SFO) ATTRIBUTE --type Integer --maxsize 4 --value 0
	$(SFO) CATEGORY --type Utf8 --maxsize 4 --value "gd"
	$(SFO) CONTENT_ID --type Utf8 --maxsize 48 --value "$(CONTENT_ID)"
	$(SFO) DOWNLOAD_DATA_SIZE --type Integer --maxsize 4 --value 0
	$(SFO) FORMAT --type Utf8 --maxsize 4 --value "obs"
	$(SFO) PARENTAL_LEVEL --type Integer --maxsize 4 --value 1
	$(SFO) SYSTEM_VER --type Integer --maxsize 4 --value 0
	$(SFO) TITLE --type Utf8 --maxsize 128 --value "$(TITLE)"
	$(SFO) TITLE_ID --type Utf8 --maxsize 12 --value "$(TITLE_ID)"
	$(SFO) VERSION --type Utf8 --maxsize 8 --value "01.00"
	cd $(STAGE) && $(BIN)/create-gp4 -out pkg.gp4 --content-id=$(CONTENT_ID) --files "eboot.bin sce_sys/param.sfo sce_sys/icon0.png sce_module/libc.prx sce_module/libSceFios2.prx $(if $(RIGHT_SPRX),sce_sys/about/right.sprx)"
	cd $(STAGE) && $(BIN)/PkgTool.Core pkg_build pkg.gp4 ../../$(DIST)
	@touch $(DIST)/.done
	@ls -l $(DIST)

clean:
	rm -rf build $(DIST)
