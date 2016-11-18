#!/bin/bash

SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

if [ -z "$PROJECT_DIR" ]; then
    PROJECT_DIR="${SCRIPT_DIR}/.."
fi

PATH="${PATH}":/usr/local/bin
cd "${PROJECT_DIR}/CyndiLauper/Models"

MODEL_NAME="CASLSpecs"

mogenerator --v2 --model "./${MODEL_NAME}.xcdatamodeld" --machine-dir "./Generated" --human-dir "."
