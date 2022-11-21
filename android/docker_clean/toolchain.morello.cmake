set(CMAKE_SYSTEM_NAME               Linux)
set(CMAKE_SYSTEM_PROCESSOR          aarch64)

# Without that flag CMake is not able to pass test compilation check
set(CMAKE_TRY_COMPILE_TARGET_TYPE   STATIC_LIBRARY)

# If needed, change these path to point at the android and library directories respectivly
set(ANDROID_DIR $ENV{HOME}/morello_workspace/android)
set(ANDROID_LIB ${ANDROID_DIR}/out/target/product/morello/obj_morello/STATIC_LIBRARIES)

set(ANDROID_LINK_SUFFIX  "${ANDROID_LIB}/libc++fs_intermediates/libc++fs.a \
${ANDROID_LIB}/libc++_static_intermediates/libc++_static.a          \
${ANDROID_LIB}/libc++demangle_intermediates/libc++demangle.a         \
${ANDROID_LIB}/libm_intermediates/libm.a                   \
-Wl,--start-group                        \
${ANDROID_LIB}/libc_intermediates/libc.a                   \
${ANDROID_LIB}/libcompiler_rt-extras_intermediates/libcompiler_rt-extras.a  \
${ANDROID_LIB}/libcompiler_rt_intermediates/libcompiler_rt.a         \
-Wl,--end-group                          \
${ANDROID_LIB}/crtend_android_intermediates/crtend_android ")

set(CMAKE_AR                llvm-ar)
set(CMAKE_ASM_COMPILER      clang)
set(CMAKE_C_COMPILER        clang)
set(CMAKE_CXX_COMPILER      clang++)
set(CMAKE_C_LINK_EXECUTABLE   "<CMAKE_C_COMPILER> <FLAGS> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES> ${ANDROID_LINK_SUFFIX}")
set(CMAKE_CXX_LINK_EXECUTABLE "<CMAKE_CXX_COMPILER> <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES> ${ANDROID_LINK_SUFFIX}")
set(CMAKE_OBJCOPY           llvm-objcopy)
set(CMAKE_RANLIB            llvm-ranlib)
set(CMAKE_SIZE              llvm-size)
set(CMAKE_STRIP             llvm-strip)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(CMAKE_C_FLAGS           "     ${CMAKE_C_FLAGS}    \
-Wno-enum-compare                                                               \
-Wno-enum-compare-switch                                                        \
-Wno-null-pointer-arithmetic                                                    \
-Wno-null-dereference                                                           \
-Wno-pointer-compare                                                            \
-Wno-xor-used-as-pow                                                            \
-Wno-final-dtor-non-final-class                                                 \
-Wno-psabi                                                                      \
-Wno-stack-protector-purecap-ignored                                            \
-march=morello+c64                                                              \
-mabi=purecap                                                                   \
-mcpu=rainier                                                                   \
-DANDROID                                                                       \
-fmessage-length=0                                                              \
-W                                                                              \
-Wall                                                                           \
-Wno-unused                                                                     \
-Winit-self                                                                     \
-Wpointer-arith                                                                 \
-no-canonical-prefixes                                                          \
-DNDEBUG                                                                        \
-UDEBUG                                                                         \
-Wno-multichar                                                                  \
-O0                                                                             \
-g                                                                              \
-fno-strict-aliasing                                                            \
-fdebug-prefix-map=/proc/self/cwd=                                              \
-D__compiler_offsetof=__builtin_offsetof                                        \
-faddrsig                                                                       \
-fcommon                                                                        \
-fexperimental-new-pass-manager                                                 \
-Wno-reserved-id-macro                                                          \
-Wno-unused-command-line-argument                                               \
-fcolor-diagnostics                                                             \
-Wno-sign-compare                                                               \
-Wno-defaulted-function-deleted                                                 \
-Wno-inconsistent-missing-override                                              \
-Wno-c99-designator                                                             \
-ftrivial-auto-var-init=zero                                                    \
-enable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang        \
-ffunction-sections                                                             \
-fdata-sections                                                                 \
-fno-short-enums                                                                \
-funwind-tables                                                                 \
-fstack-protector-strong                                                        \
-Wa,--noexecstack                                                               \
-D_FORTIFY_SOURCE=2                                                             \
-Wstrict-aliasing=2                                                             \
-nostdlibinc                                                                    \
-target aarch64-linux-android10000                                              \
-B${ANDROID_DIR}/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/aarch64-linux-android/bin    \
-DANDROID_STRICT                                                                 \
-D__LIBC_API__=10000                                                             \
-D__LIBM_API__=10000                                                             \
-D__LIBDL_API__=10000                                                            \
-I${ANDROID_DIR}/external/libarchcap/include                                     \
-I${ANDROID_DIR}/external/libcxx/include                                         \
-I${ANDROID_DIR}/external/libcxxabi/include                                      \
-I${ANDROID_DIR}/bionic/libc/include                                             \
-I${ANDROID_DIR}/external/jemalloc_new/include                                   \
-I${ANDROID_DIR}/bionic/libc/system_properties/include                           \
-I${ANDROID_DIR}/system/core/property_service/libpropertyinfoparser/include      \
-I${ANDROID_DIR}/external/libshim/include                                        \
-I${ANDROID_DIR}/external/ltp/android/include/                                   \
-Wno-macro-redefined                                                             \
-DDO_NOT_CHECK_MANUAL_BINDER_INTERFACES                                          \
-I${ANDROID_DIR}/system/core/include                                             \
-I${ANDROID_DIR}/system/media/audio/include                                      \
-I${ANDROID_DIR}/hardware/libhardware/include                                    \
-I${ANDROID_DIR}/hardware/libhardware_legacy/include                             \
-I${ANDROID_DIR}/hardware/ril/include                                            \
-I${ANDROID_DIR}/frameworks/native/include                                       \
-I${ANDROID_DIR}/frameworks/native/opengl/include                                \
-I${ANDROID_DIR}/frameworks/av/include                                           \
-isystem ${ANDROID_DIR}/bionic/libc/include                                      \
-isystem ${ANDROID_DIR}/bionic/libc/kernel/uapi                                  \
-isystem ${ANDROID_DIR}/bionic/libc/kernel/uapi/asm-arm64                        \
-isystem ${ANDROID_DIR}/bionic/libc/kernel/android/scsi                          \
-isystem ${ANDROID_DIR}/bionic/libc/kernel/android/uapi                          \
-I${ANDROID_DIR}/system/core/include                                            \
-I${ANDROID_DIR}/system/core/property_service/libpropertyinfoparser/include     \
-I${ANDROID_DIR}/system/media/audio/include                                     \
-I${ANDROID_DIR}/libnativehelper/include_jni                                     \
-Wno-void-pointer-to-enum-cast                                                   \
-Wno-void-pointer-to-int-cast                                                    \
-Wno-pointer-to-int-cast                                                         \
-Wno-tautological-constant-compare                                               \
-Wno-tautological-type-limit-compare                                             \
-Wno-reorder-init-list                                                           \
-Wno-implicit-int-float-conversion                                               \
-Wno-int-in-bool-context                                                         \
-Wno-sizeof-array-div                                                            \
-Wno-tautological-overlap-compare                                                \
-Wno-deprecated-copy                                                             \
-Wno-range-loop-construct                                                        \
-Wno-misleading-indentation                                                      \
-Wno-zero-as-null-pointer-constant                                               \
-Wno-deprecated-anon-enum-enum-conversion                                        \
-Wno-deprecated-enum-enum-conversion                                             \
-Wno-string-compare                                                              \
-Wno-enum-enum-conversion                                                        \
-Wno-enum-float-conversion                                                       \
-Wno-pessimizing-move                                                            \
-Wno-non-c-typedef-for-linkage                                                   \
-Wno-string-concatenation                                                        \
-Wno-align-mismatch                             ") 

set(CMAKE_CXX_FLAGS         "${CMAKE_C_FLAGS}   \
${CMAKE_CXX_FLAGS}                              \
-Wsign-promo                                    \
-Wimplicit-fallthrough                          \
-D_LIBCPP_ENABLE_THREAD_SAFETY_ANNOTATIONS      \
-Wno-gnu-include-next                           \
-fvisibility-inlines-hidden                     \
-D__LIBANDROIDICU_API__=1                       \
-Werror=cheri-prototypes                        \
-Werror=cheri-prototypes-strict          ")

set(CMAKE_EXE_LINKER_FLAGS  "    -target aarch64-linux-android10000                         \
-B${ANDROID_DIR}/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/aarch64-linux-android/bin   \
-Wl,-z,noexecstack                                                                                     \
-Wl,-z,relro                                                                                           \
-Wl,-z,now                                                                                             \
-Wl,--build-id=md5                                                                                     \
-Wl,--warn-shared-textrel                                                                              \
-Wl,--fatal-warnings                                                                                   \
-Wl,--no-undefined-version                                                                             \
-Wl,--exclude-libs,libgcc.a                                                                            \
-Wl,--exclude-libs,libgcc_stripped.a                                                                   \
-Wl,--exclude-libs,libcompiler_rt.a                                                                    \
-Wl,--exclude-libs,libunwind_llvm.a                                                                    \
-fuse-ld=lld                                                                                           \
-Wl,--pack-dyn-relocs=android+relr                                                                     \
-Wl,--use-android-relr-tags                                                                            \
-Wl,--no-undefined                                                                                     \
-Wl,-z,max-page-size=4096                                                                              \
-Wl,--morello-c64-plt                                                                                  \
-fuse-ld=lld                                                                                           \
-Wl,-z,max-page-size=4096                                                                              \
-Wl,--morello-c64-plt                                                                                  \
-static                                                                                                \
-nostdlib                                                                                              \
-Bstatic                                                                                               \
-Wl,--gc-sections                                                                                      \
-L${ANDROID_LIB}/dummy_lib                                                                             \
${ANDROID_LIB}/crtbegin_static_intermediates/crtbegin_static  ")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE NEVER)
