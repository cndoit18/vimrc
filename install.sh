#!/usr/bin/env bash

SCRIPT_DIR=$(
	cd $(dirname ${BASH_SOURCE[0]}) || exit
	pwd
)

ln -sfn "${SCRIPT_DIR}/vim" "${HOME}/.vim"
ln -sfn "${SCRIPT_DIR}/nvim" "${HOME}/.config/nvim"
