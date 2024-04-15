#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="redpanda-cpp"
iso_label="REDPANDA_$(date +%Y%m%d)"
iso_publisher="Red Panda C++ <https://archlinux.org>"
iso_application="Red Panda C++"
iso_version="$(date +%Y.%m.%d)"
install_dir="redpanda-cpp"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito'
           'uefi-ia32.grub.esp' 'uefi-x64.grub.esp'
           'uefi-ia32.grub.eltorito' 'uefi-x64.grub.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="erofs"
airootfs_image_tool_options=('-zlzma,109' -E 'ztailpacking,fragments,dedupe')
bootstrap_tarball_compression=(zstd -c -T0 --long -19)
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
)
