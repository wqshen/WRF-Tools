#!/bin/bash
# script to run a WRF averaging in Bash (local)
# created 13/01/2015 by Andre R. Erler, GPL v3

# general settings
JOBNAME='wrf_avg' # job name (dummy variable, since there is no queue)
INIDIR=${INIDIR:-"${PWD}"}
SCRIPTDIR="${INIDIR}/scripts/" # default location of averaging script
AVGSCRIPT='run_wrf_avg.pbs' # name of this script...
PYAVG='wrfout_average.py' # name of Python averaging script
DOMAINS='1234' # string of single-digit domain indices

# return to original working directory
cd "${INIDIR}"

# influential enviromentvariables for averaging script
export PYAVG_THREADS=${PYAVG_THREADS:-8}
export PYAVG_DOMAINS=${PYAVG_DOMAINS:-"$DOMAINS"}
export PYAVG_FILETYPES=${PYAVG_FILETYPES:-''} # use default
# options that would interfere with yearly updates
export PYAVG_OVERWRITE=${PYAVG_OVERWRITE:-'FALSE'}
export PYAVG_ADDNEW=${PYAVG_ADDNEW:-'FALSE'} 
export PYAVG_RECOVER=${PYAVG_RECOVER:-'FALSE'}
export PYAVG_DEBUG=${PYAVG_DEBUG:-'FALSE'} # add more debug output


# launch script
echo
if [[ -n "${PERIOD}" ]]; then
    time -p python "${SCRIPTDIR}/${PYAVG}" "${PERIOD}"
    ERR=$? # capture exit code      
else

    # make sure, certain variables are there...
    #~/Scripts/addVariable.sh 'PREC_ACC_C'
    #~/Scripts/addVariable.sh 'PREC_ACC_NC'
    #~/Scripts/addVariable.sh 'SNOW_ACC_NC'

    # launch actual averaging script
    time -p python "${SCRIPTDIR}/${PYAVG}"
    ERR=$? # capture exit code
fi
echo

# exit with exit code from python script
exit ${ERR}
