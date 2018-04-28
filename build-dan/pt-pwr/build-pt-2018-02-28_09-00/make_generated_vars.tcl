set DESIGN_NAME                 "interp_filt";
 set ADDITIONAL_SEARCH_PATH      "/home/ff/ee241/stdcells/synopsys-32nm/multi_vt/db  ../../icc-par/current-icc/results ../../../../ref";
 set TARGET_LIBRARY_FILES        "saed32rvt_tt1p05v25c.db  ";
 set MW_REFERENCE_LIB_DIRS       "/cells_rvt.mw ";
 set MIN_LIBRARY_FILES           "";
 set REPORTS_DIR                 "reports";
 set NETLIST_FILES               "interp_filt.output.v";
 set CONSTRAINT_FILES           "../../icc-par/current-icc/results/interp_filt.output.sdc";
 
set STRIP_PATH                  "interp_filt_tb/DUT0";
 set PT_METHOD                   "avg";
 
set PARASITIC_PATHS             "interp_filt";
 set PARASITIC_FILES             "../../icc-par/current-icc/results/interp_filt.output.sbpf.max";
 set PT_PARASITIC                "max";
 
set ACTIVITY_FILE "../../vcs-sim-gl-par/vcdplus.saif";

set PT_EXEC "vcdplus";

