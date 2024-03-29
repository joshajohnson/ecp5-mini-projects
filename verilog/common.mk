# Thanks to Konrad Beckmann for this Makefile
VERSION:=0.2
DEVICE:=12k

PACKAGE?=CABGA256

ifeq ($(DEVICE),25k)
	IDCODE?=--idcode 0x41111043 #25k
else
	IDCODE?=--idcode 0x21111043 #12k
endif

SPEED?=8
LPF_FILE?=ecp5-mini_r${VERSION}.lpf
TOP_MODULE?=top
YOSYS_OPTIONS?=

all: $(PROJ).bit

%.json: %.v $(ADD_SRC)
	yosys \
	-p "hierarchy -top $(TOP_MODULE)" \
	-p "synth_ecp5 $(YOSYS_OPTIONS) -json $@" $< $(ADD_SRC)

dot:
	yosys \
	-p "hierarchy -top $(TOP_MODULE)" \
	-p "synth_ecp5 $(YOSYS_OPTIONS)" \
	-p "show" $(PROJ).v

%_out.config: %.json
	nextpnr-ecp5 --$(DEVICE) --json $< --lpf ../$(LPF_FILE) --package $(PACKAGE) --speed $(SPEED) --textcfg $@

%.bit: %_out.config
	ecppack $(IDCODE) --compress --spimode qspi --freq 38.8 --svf $(PROJ).svf $< $@

flash: 
	# Offset to not overwrite bootloader. Set to zero if not using DFU bootloader.
	ecpprog $(PROJ).bit -o 0x00180000
# 	ecpprog $(PROJ).bit

sram: $(PROJ).bit
	ecpprog $(PROJ).bit -S

dfu: $(PROJ).bit
	dfu-util -d 1d50:614b -a 0 -R -D $(PROJ).bit

simulate:
	iverilog -Wall -o sim/$(PROJ)_tb.sim $(PROJ)_tb.v $(ADD_SRC)
	vvp sim/$(PROJ)_tb.sim -lxt2
	mv $(PROJ)_tb.lxt sim/$(PROJ)_tb.lxt
	gtkwave sim/$(PROJ)_tb.lxt sim/gtkwaveConfig.gtkw

new: 
	make clean
	cd .. && \
	cp -r $(PROJ) $(NAME) && cd $(NAME) && \
	mv $(PROJ).v $(NAME).v && mv $(PROJ)_tb.v $(NAME)_tb.v && \
	sed -i 's/$(PROJ)/$(NAME)/g' Makefile $(NAME)*

clean:
	rm -f *.svf *.bit *.config *.json sim/$(PROJ)* *.lxt 

.PHONY: dfu clean