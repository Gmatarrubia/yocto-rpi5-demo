#!/bin/bash

repoPath="$(dirname $(realpath ${BASH_SOURCE[0]}))"
targetsPath="$repoPath/targets"

# Script arguments handle
__bitbake_cmd=()
__only_shell=
__wifi_settings_interactive=
__debug=
__parallel_limit=
__cores=
__conf_name=qemu

while (( $# )); do
    case ${1,,} in
        -b|--bitbake)
            shift
            __bitbake_cmd+=("${@}")
            echo Custom bitbake command: "${__bitbake_cmd[@]}"
            ;;
        --shell)
            __only_shell=1
            echo "Only shell mode"
            ;;
        -m|--machine)
            __conf_name="$2"
            shift
            ;;
        -wi|--wifi)
            __wifi_settings_interactive=1
            ;;
        -d|--debug)
            __debug=":${targetsPath}/include/debug.yml"
            ;;
        -j)
            __parallel_limit=":${targetsPath}/include/parallel.yml"
            __cores="$2"
            shift
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
    esac
    shift
done

# Start configuration
export CONF_FILE="${targetsPath}/${__conf_name}.yml"
export KAS_BUILD_DIR="${repoPath}/build_${__conf_name}"
export DL_DIR="${repoPath}/dl"
export SSTATE_DIR="${repoPath}/sstate"
export SHELL="/bin/bash"
rm -rf "${KAS_BUILD_DIR}"/conf/*

# Check if config file exists
if [ ! -f "${CONF_FILE}" ]
then
    echo "Machine ${__conf_name} unknown"
    echo "Config file doesn't exist: ${CONF_FILE}"
    exit 2
fi

# Check if sources were downloaded
if [ ! -d "${repoPath}/sources" ]
then
    kas checkout "${CONF_FILE}"
fi

# Start environment in shell mode
if [ -n "${__only_shell}" ]
then
    kas shell -E "${CONF_FILE}${__debug}"
    exit 0
fi


if [ -z "${__bitbake_cmd[*]}" ]
then
    time kas build "${CONF_FILE}${__debug}${__parallel_limit}"
else
    echo "Executing command: ${__bitbake_cmd[*]}"
    time kas shell "${CONF_FILE}${__debug}${__parallel_limit}" -c "${__bitbake_cmd[*]}"
fi
