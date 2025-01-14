
###### Common Config ##########################################################
# sudo apt install cmake
CMAKE_EXE ?= cmake
# sudo apt install ninja-build
NINJA_EXE ?= ninja

BUILD_TYPE ?= Release
CONFIG_ARGS ?=
BIN_DIR ?= build

CORE_MANAGER_DIR ?= Avatar-FaceKey-CoreManager
SERVER_DIR ?= Avatar-FaceKey-Server
RELEASE_DIR ?= Avatar-FaceKey-Releases
ANDROID_DIR ?= Avatar-FaceKey-Android

# Print build type.
ifeq ($(findstring $(BUILD_TYPE),Release Debug),)
    $(error Invalid BUILD_TYPE:$(BUILD_TYPE))
else
    $(info BUILD_TYPE: $(BUILD_TYPE))
endif

###### Android build targets ##################################################
# Android configs.
# Download and unzip Android NDK from https://developer.android.com/ndk/downloads.
NDK_ROOT_DIR ?= ~/workspace/android-ndk-r26b
ANDROID_ABI ?= arm64-v8a
ANDROID_API_LEVEL ?= android-24
ANDROID_BIN ?= $(BIN_DIR)/Android-$(BUILD_TYPE)

config-android:
	$(CMAKE_EXE) $(CONFIG_ARGS) \
		-DCMAKE_TOOLCHAIN_FILE=$(NDK_ROOT_DIR)/build/cmake/android.toolchain.cmake \
		-DANDROID_ABI=$(ANDROID_ABI) -DANDROID_NATIVE_API_LEVEL=$(ANDROID_API_LEVEL) \
		-DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -DJXS_OS=Android -DJXS_ARCH=aarch64 \
		-GNinja -DCMAKE_MAKE_PROGRAM=$(NINJA_EXE) \
		-B $(ANDROID_BIN) -S .

build-android: config-android
	$(CMAKE_EXE) --build $(ANDROID_BIN)

clean-android:
	$(CMAKE_EXE) -E rm -rf $(ANDROID_BIN)

###### Unix x64 build targets #################################################

###### Server build ###########################################################

SERVER_BIN ?= $(BIN_DIR)/Server-$(BUILD_TYPE)

config-server:
	cd $(CORE_MANAGER_DIR) && $(CMAKE_EXE) $(CONFIG_ARGS) \
		-DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -DCMAKE_C_FLAGS=-m64 -DCMAKE_CXX_FLAGS=-m64 \
		-DENABLE_SERVER_SDK=ON -DENABLE_OPENCV=OFF \
		-B $(SERVER_BIN) -S .

build-server: config-server
	cd $(CORE_MANAGER_DIR) && $(CMAKE_EXE) --build $(SERVER_BIN)

install-server: build-server
	cp $(CORE_MANAGER_DIR)/include/avatarCoreManager.h $(SERVER_DIR)/avatar_js/avatar_core_manager/include/
	cp $(CORE_MANAGER_DIR)/$(SERVER_BIN)/libavatarcoremanager.so $(SERVER_DIR)/avatar_js/avatar_core_manager/linux/server/x64/
	cp $(CORE_MANAGER_DIR)/include/avatarCoreManager.h $(RELEASE_DIR)/avatar_core_manager/include/
	cp $(CORE_MANAGER_DIR)/$(SERVER_BIN)/libavatarcoremanager.so $(RELEASE_DIR)/avatar_core_manager/linux/x64/lib/server/
	cp $(CORE_MANAGER_DIR)/include/avatarCoreManager.h $(ANDROID_DIR)/CoreManager/src/main/cpp/

clean-server:
	cd $(CORE_MANAGER_DIR) && $(CMAKE_EXE) -E rm -rf $(SERVER_BIN)

###### Avatar Server ##########################################################

AVATAR_JS ?= $(SERVER_DIR)/avatar_js
SERVER_JS ?= $(SERVER_DIR)/avatar_server

build-avatar-js:
	cd $(AVATAR_JS) && npm install

build-avatar-server: build-avatar-js
	cd $(SERVER_JS) && npm install && node build.js

test-avatar-js: build-avatar-server
	cd $(AVATAR_JS) && ./build/demo_app
	cd $(AVATAR_JS) && node ./dist/avatar_test.js

run-avatar-server: build-avatar-server
	export LD_LIBRARY_PATH=$(PWD)/avatar_js/avatar_core_manager/linux/server/x64:${LD_LIBRARY_PATH} && \
	export DATABASE_URL=postgresql://avatar_user:password@localhost/avatar_db && \
	cd $(SERVER_JS) && node ./dist/server.js

clean-avatar-server:
	-cd $(AVATAR_JS) && rm -r build/ dist/ node_modules/
	-cd $(SERVER_JS) && rm -r build/ dist/ node_modules/

###### dotnet #################################################################

run-dotnet:
	cd avatar_client && dotnet run

###############################################################################

clean:
	$(CMAKE_EXE) -E rm -rf $(BIN_DIR)

.PHONY : *