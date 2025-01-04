#!/bin/bash

# Script to install NDK into AndroidIDE
# Author MrIkso

install_dir=$HOME
sdk_dir=$install_dir/android-sdk
cmake_dir=$sdk_dir/cmake
ndk_base_dir=$sdk_dir/ndk

ndk_dir=""
ndk_ver=""
ndk_ver_name=""
ndk_file_name=""
ndk_installed=false
cmake_installed=false
is_lzhiyong_ndk=false

run_install_cmake() {
	download_cmake 3.10.2
	download_cmake 3.18.1
	download_cmake 3.22.1
	download_cmake 3.25.1
}

download_cmake() {
	# download cmake
	cmake_version=$1
	echo "Downloading cmake-$cmake_version..."
	wget https://github.com/MrIkso/AndroidIDE-NDK/releases/download/cmake/cmake-"$cmake_version"-android-aarch64.zip --no-verbose --show-progress -N
	installing_cmake "$cmake_version"
}

copy_ndk() {
	# copy NDK from sdcard
	ndk_file_path="/sdcard/$1"
	echo "Copying NDK from $ndk_file_path..."
	if [ -f "$ndk_file_path" ]; then
		cp "$ndk_file_path" .
	else
		echo "NDK file not found at $ndk_file_path"
		exit 1
	fi
}

fix_ndk() {
	# create missing link
	if [ -d "$ndk_dir" ]; then
		echo "Creating missing links..."
		cd "$ndk_dir"/toolchains/llvm/prebuilt || exit
		ln -s linux-aarch64 linux-x86_64
		cd "$ndk_dir"/prebuilt || exit
		ln -s linux-aarch64 linux-x86_64
		cd "$install_dir" || exit

		# patching cmake config
		echo "Patching cmake configs..."
		sed -i 's/if(CMAKE_HOST_SYSTEM_NAME STREQUAL Linux)/if(CMAKE_HOST_SYSTEM_NAME STREQUAL Android)\nset(ANDROID_HOST_TAG linux-aarch64)\nelseif(CMAKE_HOST_SYSTEM_NAME STREQUAL Linux)/g' "$ndk_dir"/build/cmake/android-legacy.toolchain.cmake
		sed -i 's/if(CMAKE_HOST_SYSTEM_NAME STREQUAL Linux)/if(CMAKE_HOST_SYSTEM_NAME STREQUAL Android)\nset(ANDROID_HOST_TAG linux-aarch64)\nelseif(CMAKE_HOST_SYSTEM_NAME STREQUAL Linux)/g' "$ndk_dir"/build/cmake/android.toolchain.cmake
		ndk_installed=true
	else
		echo "NDK does not exist."
	fi
}

installing_cmake() {
	cmake_version=$1
	cmake_file=cmake-"$cmake_version"-android-aarch64.zip
	# unzip cmake
	if [ -f "$cmake_file" ]; then
		echo "Unzipping cmake..."
		unzip -qq "$cmake_file" -d "$cmake_dir"
		rm "$cmake_file"
		# set executable permission for cmake
		chmod -R +x "$cmake_dir"/"$cmake_version"/bin

		cmake_installed=true
	else
		echo "$cmake_file does not exist."
	fi
}

echo "Select which NDK version you need to install?"

select item in r17c r18b r19c r20b r21e r22b r23b r24 r26b r27b Quit; do
	case $item in
	"r17c")
		ndk_ver="17.2.4988734"
		ndk_ver_name="r17c"
		break
		;;
	"r18b")
		ndk_ver="18.1.5063045"
		ndk_ver_name="r18b"
		break
		;;
	"r19c")
		ndk_ver="19.2.5345600"
		ndk_ver_name="r19c"
		break
		;;
	"r20b")
		ndk_ver="20.1.5948944"
		ndk_ver_name="r20b"
		break
		;;
	"r21e")
		ndk_ver="21.4.7075529"
		ndk_ver_name="r21e"
		break
		;;
	"r22b")
		ndk_ver="22.1.7171670"
		ndk_ver_name="r22b"
		break
		;;
	"r23b")
		ndk_ver="23.2.8568313"
		ndk_ver_name="r23b"
		break
		;;
	"r24")
		ndk_ver="24.0.8215888"
		ndk_ver_name="r24"
		break
		;;
	"r26b")
		ndk_ver="26.1.10909125"
		ndk_ver_name="r26b"
		is_lzhiyong_ndk=true
		break
		;;
  	"r27b")
		ndk_ver="27.1.12297006"
		ndk_ver_name="r27b"
		is_lzhiyong_ndk=true
		break
		;;
	"Quit")
		echo "Exit.."
		exit
		;;
	*)
		echo "Oops"
		;;
	esac
done

echo "Selected version $ndk_ver_name ($ndk_ver) to install"
echo 'Warning! This NDK is only for aarch64'
cd "$install_dir" || exit
# checking if previous installed NDK and cmake

ndk_dir="$ndk_base_dir/$ndk_ver"
ndk_file_name="android-ndk-$ndk_ver_name-aarch64.zip"

if [ -d "$ndk_dir" ]; then
	echo "$ndk_dir exists. Deleting NDK $ndk_ver..."
	rm -rf "$ndk_dir"
else
	echo "NDK does not exist."
fi

if [ -d "$cmake_dir/3.10.1" ]; then
	echo "$cmake_dir/3.10.1 exists. Deleting cmake..."
	rm -rf "$cmake_dir"
fi

if [ -d "$cmake_dir/3.18.1" ]; then
	echo "$cmake_dir/3.18.1 exists. Deleting cmake..."
	rm -rf "$cmake_dir"
fi

if [ -d "$cmake_dir/3.22.1" ]; then
	echo "$cmake_dir/3.22.1 exists. Deleting cmake..."
	rm -rf "$cmake_dir"
fi

if [ -d "$cmake_dir/3.23.1" ]; then
	echo "$cmake_dir/3.23.1 exists. Deleting cmake..."
	rm -rf "$cmake_dir"
fi

if [[ $is_lzhiyong_ndk == true ]]; then
	copy_ndk "$ndk_file_name"
else
	copy_ndk "$ndk_file_name"
fi

if [ -f "$ndk_file_name" ]; then
	echo "Unzipping NDK $ndk_ver_name..."
	unzip -qq $ndk_file_name
	rm $ndk_file_name

	# moving NDK to Android SDK directory
	if [ -d "$ndk_base_dir" ]; then
		mv android-ndk-$ndk_ver_name "$ndk_dir"
	else
		echo "NDK base dir does not exist. Creating..."
		mkdir -p "$sdk_dir"/ndk
		mv android-ndk-$ndk_ver_name "$ndk_dir"
	fi

	if [[ $is_lzhiyong_ndk == false ]]; then
		fix_ndk
	else
		ndk_installed=true
	fi

else
	echo "$ndk_file_name does not exist."
fi

if [ -d "$cmake_dir" ]; then
	cd "$cmake_dir"
	run_install_cmake
else
	mkdir -p "$cmake_dir"
	cd "$cmake_dir"
	run_install_cmake
fi

if [[ $ndk_installed == true && $cmake_installed == true ]]; then
	echo 'Installation Finished. NDK has been installed successfully, please restart AndroidIDE!'
else
	echo 'NDK and cmake were not installed successfully!'
fi
