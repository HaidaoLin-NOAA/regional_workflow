#
#-----------------------------------------------------------------------
#
# This file defines and then calls a function that sets known locations
# of files on supported platforms.
#
#-----------------------------------------------------------------------
#
function set_known_sys_dir() {

  # Usage:
  #  set_known_sys_dir model
  #
  #  model is the name of the external model
  #
  local known_sys_dir model_name

  model=$1
  #
  #-----------------------------------------------------------------------
  #
  # Set the system directory (i.e. location on disk, not on HPSS) in
  # which the files generated by the external model specified by
  # EXTRN_MDL_NAME_ICS that are necessary for generating initial
  # condition (IC) and surface files for the FV3SAR are stored (usually
  # for a limited time, e.g. for the GFS external model, 2 weeks on
  # WCOSS and 2 days on hera).  If for a given cycle these files are
  # available in this system directory, they will be copied over to a
  # subdirectory under the cycle directory.  If these files are not
  # available in the system directory, then we search for them
  # elsewhere, e.g. in the mass store (HPSS).
  #
  #-----------------------------------------------------------------------
  #

  # Set some default known locations on supported platforms. Not all
  # platforms have known input locations
  case "${model}" in

  "GSMGFS")
    case "$MACHINE" in
    "ODIN")
      known_sys_dir=/scratch/ywang/EPIC/GDAS/2019053000_mem001
      ;;
    "CHEYENNE")
      known_sys_dir=/glade/p/ral/jntp/UFS_CAM/COMGFS
      ;;
    "STAMPEDE")
      known_sys_dir=/scratch/00315/tg455890/GDAS/20190530/2019053000_mem001
      ;;
    esac
    ;;

  "FV3GFS")
    case "$MACHINE" in
    "WCOSS_CRAY")
      ;& # Fall through
    "WCOSS_DELL_P3")
      known_sys_dir=/gpfs/dell1/nco/ops/com/gfs/prod
      ;;
    "HERA")
      known_sys_dir=/scratch1/NCEPDEV/rstprod/com/gfs/prod
      ;;
    "JET")
      known_sys_dir=/public/data/grids/gfs/nemsio
      ;;
    "ODIN")
      known_sys_dir=/scratch/ywang/test_runs/FV3_regional/gfs
      ;;
    "STAMPEDE")
      known_sys_dir=/scratch/00315/tg455890/GDAS/20190530/2019053000_mem001
      ;;
    "CHEYENNE")
      known_sys_dir=/glade/p/ral/jntp/UFS_CAM/COMGFS}
      ;;
    esac
    ;;

  "RAP")
    case "$MACHINE" in
    "WCOSS_CRAY")
      ;& # Fall through
    "WCOSS_DELL_P3")
      known_sys_dir=/gpfs/hps/nco/ops/com/rap/prod
      ;;
    esac
    ;;

  "HRRR")
    case "$MACHINE" in
    "WCOSS_CRAY")
      ;& # Fall through
    "WCOSS_DELL_P3")
      known_sys_dir=/gpfs/hps/nco/ops/com/hrrr/prod
      ;;
    esac
    ;;

  "NAM")
    case "$MACHINE" in
    "WCOSS_CRAY")
      ;& # Fall through
    "WCOSS_DELL_P3")
      known_sys_dir=/gpfs/dell1/nco/ops/com/nam/prod
      ;;
    esac
    ;;

  esac

  echo $known_sys_dir
}

function set_extrn_mdl_params() {
  #
  #-----------------------------------------------------------------------
  #
  # Use known locations or COMINgfs as default, depending on RUN_ENVIR
  #
  #-----------------------------------------------------------------------
  #
  if [ "${RUN_ENVIR}" = "nco" ]; then
    EXTRN_MDL_SYSBASEDIR_ICS="${EXTRN_MDL_SYSBASEDIR_ICS:-$COMINgfs}"
    EXTRN_MDL_SYSBASEDIR_LBCS="${EXTRN_MDL_SYSBASEDIR_LBCS:-$COMINgfs}"
  else
    EXTRN_MDL_SYSBASEDIR_ICS="${EXTRN_MDL_SYSBASEDIR_ICS:-$(set_known_sys_dir \
    ${EXTRN_MDL_NAME_ICS})}"
    EXTRN_MDL_SYSBASEDIR_LBCS="${EXTRN_MDL_SYSBASEDIR_LBCS:-$(set_known_sys_dir \
    ${EXTRN_MDL_NAME_LBCS})}"
  fi

  #
  #-----------------------------------------------------------------------
  #
  # Set EXTRN_MDL_LBCS_OFFSET_HRS, which is the number of hours to shift 
  # the starting time of the external model that provides lateral boundary 
  # conditions.
  #
  #-----------------------------------------------------------------------
  #
  case "${EXTRN_MDL_NAME_LBCS}" in
    "RAP")
      EXTRN_MDL_LBCS_OFFSET_HRS=${EXTRN_MDL_LBCS_OFFSET_HRS:-"3"}
      ;;
    "*")
      EXTRN_MDL_LBCS_OFFSET_HRS=${EXTRN_MDL_LBCS_OFFSET_HRS:-"0"}
      ;;
  esac
}
#
#-----------------------------------------------------------------------
#
# Call the function defined above.
#
#-----------------------------------------------------------------------
#
set_extrn_mdl_params
