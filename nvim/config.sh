#!/bin/bash
# Script for fixing downloaded plugins

PYTHON3_LIB="lib/python3*/site-packages"

# Copy VSCode stubs to Python site-packages
function cp_vs_stubs() {
    VS_STUBS="$HOME/.vscode/extensions/ms-python.vscode-pylance-*/dist/bundled"
    destination=$1/$PYTHON3_LIB
    if [[ -e $VS_STUBS ]]; then
        for stubs in $VS_STUBS/stubs $VS_STUBS/native-stubs; do
            cp -ru $stubs/* $destination
        done
    fi
}

# Cmp_signature_help nvim plugin config:
CMP_SH_LUA="$HOME/.local/share/nvim/plugin/cmp-nvim-lsp-signature-help/lua/cmp_nvim_lsp_signature_help/init.lua"
if [[ -e $CMP_SH_LUA ]]; then
    sed -Ei 's/ (preselect)/ --\1/g' $CMP_SH_LUA 
fi

# Remove default colorschemes
# sudo rm -f /usr/share/nvim/runtime/colors/*

cp_vs_stubs $HOME/.local

while [[ $1 ]]; do
    case $1 in
        -v | --virtualenv)
            shift
            env_path="$1"
            cp_vs_stubs $env_path
        -h | --help | *)
            echo "Usage: ./config.sh [-v, --virtualenv | -h, --help]";;
    esac
    shift
done

