#!/usr/bin/env bash

has_cmd() {
    hash "$1" &> /dev/null
    return $?
}

if has_cmd proxychains; then
    proxychains -q mbsync --all --verbose
else
    mbsync --all --verbose
fi
