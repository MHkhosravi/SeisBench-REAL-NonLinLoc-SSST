#!/bin/bash -w

# Remove generated files from the focused SeisBench -> REAL -> NonLinLoc/SSST workflow.

rm -rf Data/waveform_mseed Data/waveform_sac Data/fname.csv Data/station.dat
rm -rf Pick/SeisBench/picks Pick/SeisBench/results

rm -f REAL/*.catalog_sel.txt REAL/*.phase_sel.txt REAL/*.hypolocSA.dat REAL/*.hypophase.dat
rm -f REAL/catalog_allday.txt REAL/catalogSA_allday.txt REAL/phase_allday.txt REAL/phaseSA_allday.txt
rm -f REAL/phase_best_allday.txt

rm -rf NonLinLoc/obs NonLinLoc/obs_files NonLinLoc/run NonLinLoc/model NonLinLoc/time NonLinLoc/loc
rm -rf NonLinLoc/out NonLinLoc/tmp NonLinLoc/ssst
rm -f NonLinLoc/nlloc.in NonLinLoc/loc2ssst.in NonLinLoc/ssst.list NonLinLoc/Grid2GMT_SSST.cpt
