#!/bin/bash -e
cd "$(dirname "$0")"
if [ -f "build-android.conf" ]; then
    source build-android.conf
else
    echo "Modify 'build-android.conf' before continue."
    cp build-android.conf.defaults build-android.conf
    exit 1
fi

lib_path=$(adb shell pm path com.stxr.senseinceptionviewer)
lib_path=${lib_path#package:}
lib_path=${lib_path%/*}

adb root

if [ ${ANDROID_ABI} = "armeabi-v7a" ]; then
    echo "pushing 32bit lib"
    adb push build/android/${ANDROID_ABI}/utils/use_boost /data/sdcard/
    adb push build/android/${ANDROID_ABI}/utils/use_ceres /data/sdcard/
    adb push build/android/${ANDROID_ABI}/utils/use_core /data/sdcard/
    adb push build/android/${ANDROID_ABI}/utils/use_eigen /data/sdcard/
    adb push build/android/${ANDROID_ABI}/utils/use_lyra /data/sdcard/
    adb push build/android/${ANDROID_ABI}/utils/use_range /data/sdcard/
    adb push build/android/${ANDROID_ABI}/utils/use_spdlog /data/sdcard/
else
    echo "pushing 64bit lib"
    adb push build/android/${ANDROID_ABI}/utils/use_boost /data/sdcard/
    adb push build/android/${ANDROID_ABI}/utils/use_ceres /data/sdcard/
    adb push build/android/${ANDROID_ABI}/utils/use_core /data/sdcard/
    adb push build/android/${ANDROID_ABI}/utils/use_eigen /data/sdcard/
    adb push build/android/${ANDROID_ABI}/utils/use_lyra /data/sdcard/
    adb push build/android/${ANDROID_ABI}/utils/use_range /data/sdcard/
    adb push build/android/${ANDROID_ABI}/utils/use_spdlog /data/sdcard/
fi

adb logcat -c
