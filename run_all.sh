#!/bin/bash -w

# End-to-end workflow:
#   1. Optional waveform download and SeisBench input preparation.
#   2. SeisBench phase picking.
#   3. REAL association.
#   4. Optional NonLinLoc location.
#   5. Optional iterative NonLinLoc/SSST relocation.

start=`date +%s`

########################### Data ###########################
irun=0 # 0: skip, 1: download waveforms and prepare station/fname files

if (($irun == 1))
then
    cd Data
    echo 'downloading waveform data'
    python waveform_download_mseed.py || { echo 'Error in data download'; exit 1; }

    echo 'preparing SeisBench inputs'
    python seisbench_input.py || { echo 'Error in data preparation'; exit 1; }
    cd ..
else
    echo 'Data download/preparation step skipped'
fi

######################### SeisBench #########################
ipick=1 # 0: skip, 1: run SeisBench picker
seisbench_model=PhaseNet_original
seisbench_start_date=2016-10-14
seisbench_nday=1
seisbench_device=auto

if (($ipick == 1))
then
    echo 'running SeisBench picker'
    cd Pick/SeisBench
    python runseisbench.py \
        --models "$seisbench_model" \
        --start-date "$seisbench_start_date" \
        --nday "$seisbench_nday" \
        --device "$seisbench_device" || { echo 'Error running SeisBench'; exit 1; }
    cd ../..
else
    echo 'SeisBench picking step skipped'
fi

########################### REAL ###########################
ittable=0 # 0: skip, 1: build REAL travel-time table
ireal=1   # 0: skip, 1: run REAL association

if (($ittable == 1))
then
    echo 'building REAL travel-time table'
    cd REAL/tt_db
    python taup_tt.py || { echo 'Error building travel time table'; exit 1; }
    cd ../..
else
    echo 'Travel-time table building step skipped'
fi

if (($ireal == 1))
then
    echo 'running REAL association'
    cd REAL
    perl runREAL.pl "$seisbench_model" || { echo 'Error running REAL'; exit 1; }
    cd ..
else
    echo 'REAL association step skipped'
fi

######################### NonLinLoc #########################
inlloc=0 # 0: skip, 1: run initial NonLinLoc location

if (($inlloc == 1))
then
    echo 'running NonLinLoc location'
    cd NonLinLoc
    bash run_nonlinloc.sh || { echo 'Error running NonLinLoc'; exit 1; }
    cd ..
else
    echo 'NonLinLoc location step skipped'
fi

######################## NonLinLoc SSST #####################
issst=0 # 0: skip, 1: run iterative SSST relocation

if (($issst == 1))
then
    echo 'running NonLinLoc/SSST relocation'
    cd NonLinLoc
    bash run_ssst_relocations.sh || { echo 'Error running NonLinLoc/SSST'; exit 1; }
    cd ..
else
    echo 'NonLinLoc/SSST relocation step skipped'
fi

end=`date +%s`
echo 'total time' $((end-start)) 'sec'
