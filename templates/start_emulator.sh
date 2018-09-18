#!/usr/bin/env bash

vnc_enabled=$VNC_ENABLED

console_port=$CONSOLE_PORT
adb_port=$ADB_PORT
adb_server_port=$ADB_SERVER_PORT
emulator_opts=$EMULATOR_OPTS

if [ -z "$console_port" ]
then
  console_port="5554"
fi
if [ -z "$adb_port" ]
then
  adb_port="5555"
fi
if [ -z "$adb_server_port" ]
then
  adb_server_port="5037"
fi
if [ -z "$emulator_opts" ]
then
  if [ "$vnc_enabled" = true ]
  then
    emulator_ui_opts="-screen multi-touch"
  else
    emulator_ui_opts="-no-window"
  fi
  emulator_opts="${emulator_ui_opts} -no-boot-anim -noaudio -nojni -wipe-data -netfast -verbose -camera-back none -camera-front none -skip-adb-auth"
fi

if [ "$vnc_enabled" = true ]
then
  export DISPLAY=:1
  Xvfb :1 +extension GLX +extension RANDR +extension RENDER +extension XFIXES -screen 0 1024x768x24 &
  fluxbox -display ":1.0" &
  x11vnc -display :1 -nopw -forever &
fi

# Set up and run emulator
# qemu references bios by relative path
cd /opt/android-sdk-linux/emulator

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/android-sdk-linux/emulator/lib64/qt/lib:/opt/android-sdk-linux/emulator/lib64/libstdc++:/opt/android-sdk-linux/emulator/lib64:/opt/android-sdk-linux/emulator/lib64/gles_swiftshader
LIBGL_DEBUG=verbose ./qemu/linux-x86_64/qemu-system-i386 -avd x86 -ports $console_port,$adb_port $emulator_opts -qemu $QEMU_OPTS