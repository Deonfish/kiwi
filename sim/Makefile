# uvm makefile application version
VCS_UVM_HOME = $(VCS_HOME)/etc/uvm-1.1
TESTNAME ?=
UVM_VERBOSITY=UVM_LOW

FILE = ../tb/tb_flist.f 

ifeq ($(PROJ_NAME), )
	WAVEFILE = wave.fsdb
else
	WAVEFILE = $(PROJ_NAME)_wave.fsdb
endif

UVM_OPTION_VCS  = +incdir+${VCS_UVM_HOME}/src+${VCS_UVM_HOME}/vcs  \
			      ${VCS_UVM_HOME}/src/uvm_pkg.sv \
			      ${VCS_UVM_HOME}/src/dpi/uvm_dpi.cc -CFLAGS -DVCS

VCS = vcs \
    -sverilog \
    -full64 \
    -fsdb \
    -timescale=1ns/1ps \
    -debug_all \
	-LDFLAGS -Wl,--no-as-needed \
    -l compole.log \
	-f $(FILE)
    # -cpp g++-4.8 -cc gcc-4.8  \
	# ${UVM_OPTION_VCS} \
    # -ntb_opts uvm-1.1 \

SIMV = ./simv \
	   -l vcs_sim.log
	   # +UVM_VERBOSITY=$(UVM_VERBOSITY)  \

VERDI = verdi -nologo -f $(FILE) -ssf $(WAVEFILE) -sswr $(PROJ_HOME)/signal.rc &

all: comp run

vcs: comp run

comp:
	$(VCS)

run:
	$(SIMV)

verdi:
	$(VERDI)

clean:
	rm -rf *~ csrc core simv* vc_hdrs.h ucli.key urg* *.log verdiLog sharedMem.dat novas* DVE* *.svf *.fsdb
