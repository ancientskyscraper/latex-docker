#!/bin/env bash

DEFAULT_SRC_FILE="main.tex"
DOCKER_IMAGE_NAME="latex" # Name of the Docker image containing LaTeX

SCRIPT_DESCRIPTION='Use texlive within a Docker container to compile a LaTeX document'
SCRIPT_PATH=$(readlink -f "$0")       # Use `readlink` to return name this script's actual source file,
SCRIPT_FILENAME="${SCRIPT_PATH##*/}"  #   even if the user is running it via symlink.

function show_usage() {
  echo "${SCRIPT_DESCRIPTION}"
  echo # newline
  echo "USAGE: ${SCRIPT_FILENAME} [--src=MAIN.TEX]"
  echo # newline
  echo "    --src=main.tex (optional)   LaTeX document to compile"
  echo "                                  (defaults to: \`${DEFAULT_SRC_FILE}\`)"
  echo # newline
}

# Set default
src="${DEFAULT_SRC_FILE}"

# Process arguments; https://www.golinuxcloud.com/beginners-guide-to-use-script-arguments-in-bash-with-examples/
while [ -n "$1" ]; do
  if [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
    show_usage
    exit

  elif [[ ${1%%=*} == "--src" ]]; then
    src=${1#*=} # Assign text beyond "=" to a variable

  else
    show_usage
    echo # new line
    echo -e "***\n*** Aborting! Unrecognized option: ${1}\n***"
    exit 64 #EX_USAGE
  fi
shift
done

# Check that we have the required arguments
if [ ! -v src ]; then
  echo -e "***\n*** Aborting! Missing argument: \`src\`\n***"
  echo # new line
  show_usage
  exit 64 #EX_USAGE
fi


# ----------------------
# Done parsing arguments; get on with actual work
# ----------------------

# Exit on any sort of error from this point on.
set -eo pipefail

# First script output; describe what it is, what it does
echo "${SCRIPT_FILENAME}: ${SCRIPT_DESCRIPTION}"
echo #newline

# Wrap a boilerplate `bash` statement that executes an arbitrary command within the Docker container
function run_command_in_docker_container() {
	docker run --rm -v "$(pwd):/tmp" "${DOCKER_IMAGE_NAME}" "$@" # `$@` represents all arguments to this function
}


# ----------------------
# Launch LaTeX compile
# ----------------------

time run_command_in_docker_container \
  latexmk -pdflatex='/usr/bin/pdflatex' -pdf "${src}" # https://mg.readthedocs.io/latexmk.html


# ----------------------
# Tell user where to find/modify this script
# ----------------------

echo #newline
echo "Script finished: \`${SCRIPT_PATH}\`"
