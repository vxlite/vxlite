# defs.mk - general definitions of makefile
#


OS := $(shell uname -s)

# setup program suffix

ifneq (,$(findstring Linux, $(OS)))
SUFFIX :=
else
SUFFIX :=.exe
endif

# compiler and linker definitions

CC      :=
CPP     :=
AS      :=
LD      :=
OBJCOPY :=
STRIP :=

# common tools

RM       := rm
MV       := mv
CP       := cp
SED      := sed
TEE      := tee
TOUCH    := touch
BASENAME := basename
MKDIR    := mkdir

# this is a workaround on Windows

ifeq (,$(findstring Linux, $(OS)))
DATE     := $(WIND_HOME)/$(WIND_VERSION)/host/binutils/$(WIND_HOST_TYPE)/bin/date$(SUFFIX)
else
DATE     := date
endif

CONF    := build/tools/kconfig/conf$(SUFFIX)
MCONF    := build/tools/kconfig/mconf$(SUFFIX)

# toolchain flags

CFLAGS   :=
LDFLAGS  :=
CFLAGS   :=




