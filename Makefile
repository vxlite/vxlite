
__vxl_tag := VXL
__vxl_info = $(info $(__vxl_tag): $1 $2)
__vxl_log = $(warning $(__vxl_tag): $1 $2)
__vxl_die = $(error $(__vxl_tag): $1 $2)

output ?= build/target
rootdir := $(subst \,/,$(shell pwd))

ifdef V 
QUIET :=
else
QUIET := @
endif

dot-config := $(output)/config.mk
bsp :=
arch :=
variant :=

# export variable

export bsp
export arch
export variant

ifndef bsp
$(if $(wildcard $(dot-config)),$(call __vxl_log, using config file $(dot-config)),\
	$(call __vxl_die, $(dot-config) does not exist\
               (try to run make defconfig bsp=xxx)))
endif

ifneq (,$(wildcard $(dot-config)))
include $(dot-config)
bsp := $(shell grep _WRS_CONFIG_BSP= $(dot-config) | sed -re "s/^.*=//g")
endif

include bsp/$(bsp)/Makefile
include arch/$(arch)/defs_$(variant).mk

define handle-config
	$(QUIET)$(RM) -f .config.old
	$(QUIET)$(MV) -f .config $(output)/config.mk
	$(QUIET)echo "_WRS_CONFIG_BSP=$(bsp)" >> $(output)/config.mk
	$(QUIET)$(SED) -re "/^#/d" $(output)/config.mk > $(output)/autoconfig.h
	$(QUIET)$(SED) -i -re \
		"s/^_WRS_CONFIG_([_a-zA-Z][_a-zA-Z0-9]*)=(.*)/#define _WRS_CONFIG_\1    \2/g" \
		$(output)/autoconfig.h
	$(QUIET)$(SED) -i -re \
		"s/(.*)\by\b/\1 1/g" $(output)/autoconfig.h
endef

defconfig:
	$(QUIET)echo "++making defconfig for BSP $(bsp)"
ifeq (,$(wildcard $(output)))
	$(QUIET)$(call make-target-if-not,$(output))
endif
	$(QUIET)$(CONF) --alldefconfig vxlite.config
	$(handle-config)
	$(QUIET)echo "++done"

mconfig:
	$(QUIET)$(MCONF) vxlite.config
	$(handle-config)

include build/mk/defs.mk
