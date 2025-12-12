# I have no idea if this still works

[[ -d ${HOME}/esp32 ]] && {
  export IDF_PATH="${HOME}/esp32/esp-idf"
  export PATH="${HOME}/esp32/xtensa-esp32-elf/bin:${MODDABLE}/build/bin/mac/release:$PATH"
  export UPLOAD_PORT="/dev/cu.SLAB_USBtoUART"
}

[[ -d ${HOME}/projects/moddable/moddable ]] && {
  export MODDABLE="${HOME}/projects/moddable/moddable"
  export PATH="${MODDABLE}/build/bin/mac/release:$PATH"
}
