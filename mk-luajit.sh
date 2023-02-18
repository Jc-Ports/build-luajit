#!/bin/bash
# see http://luajit.org/install.html for details
# there, a call like one of the following is recommended

NDK=$ANDROID_NDK_HOME

# For 32 bits (armeabi-v7a and x86) we built against platform-14 (ICS)
# For 64 bits (arm64-v8a and x86_64) we built against platform-21 (Lollipop)

DEST=$(cd "$(dirname "$0")" && pwd)/build/$1

if [ $(uname) = "Linux" ]; then
	HOST_ARCH="linux-x86_64"
elif [ $(uname) = "Darwin" ]; then
	HOST_ARCH="darwin-x86-64"
fi

case "$1" in
    clean)
        make -C luajit clean
        ;;
    armeabi-v7a)
        # Android/ARM, armeabi-v7a (ARMv7 VFP)
        NDKABI=${NDKABI:-14}
        TCVER=("${NDK}"/toolchains/arm-linux-androideabi-4.*)
        NDKP=${TCVER[0]}/prebuilt/${HOST_ARCH}/bin/arm-linux-androideabi-
        NDKF="--sysroot ${NDK}/platforms/android-${NDKABI}/arch-arm"
        NDKARCH="-march=armv7-a -mfloat-abi=softfp -Wl,--fix-cortex-a8"
        make -C luajit HOST_CC="gcc -m32" CFLAGS="-O2 -pipe" HOST_CFLAGS="-O2 -pipe -mtune=generic" LDFLAGS="" HOST_LDFLAGS="" TARGET_CFLAGS="${CFLAGS}" TARGET_LDFLAGS="${LDFLAGS}" TARGET_LIBS="${EXTRA_LIBS}" TARGET_SONAME="libluajit.so" INSTALL_SONAME="libluajit.so" CROSS="$NDKP" TARGET_FLAGS="${NDKF} ${NDKARCH}" TARGET_SYS=Linux DESTDIR="${DEST}" PREFIX=
        ;;
    arm64-v8a)
        # Android/ARM, arm64-v8a (ARM64 VFP4, NEON)
        NDKABI=${NDKABI:-21}
        TCVER=("${NDK}"/toolchains/aarch64-linux-android-4.*)
        NDKP=${TCVER[0]}/prebuilt/${HOST_ARCH}/bin/aarch64-linux-android-
        NDKF="--sysroot ${NDK}/platforms/android-${NDKABI}/arch-arm64"
        make -C luajit HOST_CC="gcc" CFLAGS="-O2 -pipe" HOST_CFLAGS="-O2 -pipe -mtune=generic" LDFLAGS="" HOST_LDFLAGS="" TARGET_CFLAGS="${CFLAGS}" TARGET_LDFLAGS="${LDFLAGS}" TARGET_LIBS="${EXTRA_LIBS}" TARGET_SONAME="libluajit.so" INSTALL_SONAME="libluajit.so" CROSS="$NDKP" TARGET_FLAGS="${NDKF}" TARGET_SYS=Linux DESTDIR="${DEST}" PREFIX=
        ;;
    x86)
        # Android/x86, x86 (i686 SSE3)
        NDKABI=${NDKABI:-14}
        TCVER=("${NDK}"/toolchains/x86-4.*)
        NDKP=${TCVER[0]}/prebuilt/${HOST_ARCH}/bin/i686-linux-android-
        NDKF="--sysroot ${NDK}/platforms/android-${NDKABI}/arch-x86"
        make -C luajit HOST_CC="gcc -m32" CFLAGS="-O2 -pipe" HOST_CFLAGS="-O2 -pipe -mtune=generic" LDFLAGS="" HOST_LDFLAGS="" TARGET_CFLAGS="${CFLAGS}" TARGET_LDFLAGS="${LDFLAGS}" TARGET_LIBS="${EXTRA_LIBS}" TARGET_SONAME="libluajit.so" INSTALL_SONAME="libluajit.so" CROSS="$NDKP" TARGET_FLAGS="$NDKF" TARGET_SYS=Linux DESTDIR="${DEST}" PREFIX=
        ;;
    x86_64)
        # Android/x86_64, x86_64
        NDKABI=${NDKABI:-21}
        TCVER=("${NDK}"/toolchains/x86_64-4.*)
        NDKP=${TCVER[0]}/prebuilt/${HOST_ARCH}/bin/x86_64-linux-android-
        NDKF="--sysroot ${NDK}/platforms/android-${NDKABI}/arch-x86_64"
        make -C luajit HOST_CC="gcc" CFLAGS="-O2 -pipe" HOST_CFLAGS="-O2 -pipe -mtune=generic" LDFLAGS="" HOST_LDFLAGS="" TARGET_CFLAGS="${CFLAGS}" TARGET_LDFLAGS="${LDFLAGS}" TARGET_LIBS="${EXTRA_LIBS}" TARGET_SONAME="libluajit.so" INSTALL_SONAME="libluajit.so" CROSS="$NDKP" TARGET_FLAGS="${NDKF}" TARGET_SYS=Linux DESTDIR="${DEST}" PREFIX=
        ;;
esac
