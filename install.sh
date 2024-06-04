#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)
ln -sfn "${SCRIPT_DIR}/vim" "${HOME}/.vim"

