#!/usr/bin/env bash

./setup_adb_redirection.sh

# Moving adb binary away so that stopping adb server with delay will release the emulator and will make it available for external connections
mv /opt/android-sdk-linux/platform-tools/adb /opt/android-sdk-linux/platform-tools/_adb
sleep 30 && _adb kill-server &

./setup_android_config_from_environment.sh

./start_emulator.sh
