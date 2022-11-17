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

# TODO add script for proper plugins update
NVIM_PLUGIN_DIR="$HOME/.local/share/nvim/plugin"
# Cmp_signature_help plugin config:
CMP_SH_LUA="$NVIM_PLUGIN_DIR/cmp-nvim-lsp-signature-help/lua/cmp_nvim_lsp_signature_help/init.lua"
if [[ -e $CMP_SH_LUA ]]; then
    sed -Ei 's/ (preselect)/ --\1/g' $CMP_SH_LUA
fi
# Nvim_tree plugin config:
NVIM_TREE_LUA="$NVIM_PLUGIN_DIR/nvim-tree.lua/lua/nvim-tree/view.lua"
if [[ -e $NVIM_TREE_LUA ]]; then
    sed -Ei 's/ + 3 -- plus some padding//g' $NVIM_TREE_LUA
fi

# Remove default colorschemes
# sudo rm -f /usr/share/nvim/runtime/colors/*

cp_vs_stubs $HOME/.local

while [[ $1 ]]; do
    case $1 in
        -v | --virtualenv)
            shift
            env_path="$1"
            cp_vs_stubs $env_path;;
        -h | --help | *)
            echo "Usage: ./config.sh [-v, --virtualenv | -h, --help]";;
    esac
    shift
done

