#!/bin/bash

set -euxo pipefail

_ROOT_DIR="$(pwd)"
_TEMP_DIR="$(TEMPLATE=redpanda-livecd mktemp -d)"

_SUDO=""
[[ $EUID -ne 0 ]] && _SUDO="sudo"

function fn-check-deps() {
  _deps=("base-devel" "devtools" "archiso")
  for dep in "${_deps[@]}"; do
    if ! pacman -Q "$dep" &>/dev/null; then
      echo "missing dependency: $dep"
      exit 1
    fi
  done
  mkdir -p "$_ROOT_DIR/repo" "$_ROOT_DIR/out"
}

function fn-build-aur-redpanda-cpp {
  cd "$_ROOT_DIR/aur/redpanda-cpp"
  extra-x86_64-build
  cp redpanda-cpp-*-x86_64.pkg.tar.zst "$_ROOT_DIR/repo"
}

function fn-create-repo {
  cd "$_ROOT_DIR/repo"
  repo-add aur.db.tar.gz $(ls *.pkg.tar.zst | sort --version-sort)
}

function fn-create-profile {
  mkdir -p "$_TEMP_DIR/profile"
  cp -r "$_ROOT_DIR"/minimal/* "$_TEMP_DIR/profile"

  sed -i "s|__AUR_LOCAL_REPO_PATH__|$_ROOT_DIR/repo|" "$_TEMP_DIR/profile/pacman.conf"
}

function fn-make-iso() {
  $_SUDO mkarchiso -v -w "$_TEMP_DIR/work" -o "$_ROOT_DIR/out" "$_TEMP_DIR/profile"
}


fn-check-deps
# fn-build-aur-redpanda-cpp
fn-create-repo
fn-create-profile
fn-make-iso
