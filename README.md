# dotfiles
my doc files

# Android cmake out of gradle

要使用Android SDK中的cmake和ninja。编译命令如下：
```powershell

cmake .. \
  -DCMAKE_TOOLCHINA_FILE="${NDK}/build/cmake/android.toolchain.cmake" \
  -DANDROID_ABI=arm64-v8a \
  -DANDROID_API_LEVEL=26 \
  -DCMAKE_MAKE_PROGRAM="${SDK}/cmake/${Version}/bin/ninja" \
  -GNinja
  
${SDK}/cmake/${Version}/bin/ninja
```

# NDK 下载网址 
https://developer.android.google.cn/ndk/downloads/
