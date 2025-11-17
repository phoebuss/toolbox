#!/bin/env bash

SCRIPT_DIR=$(dirname $(realpath ${BASH_SOURCE[0]}))

. $SCRIPT_DIR/CSI_color.sh

SGR_RESET=$'\[\e[0m\]'
SGR_BOLD=$'\[\e[1m\]'
SGR_REVERSE=$'\[\e[7m\]'
SGR_NOREVERSE=$'\[\e[27m\]'
