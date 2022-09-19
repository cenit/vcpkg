vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO AravisProject/aravis
    REF fe36369e0416fe22b3df0fd35e66918f7eea202c
    SHA512 585479529282e72d8515d46d5d0be3783c5bad57481f8b4f8bcbf702120280149f4c5dea41330225ec00243ff7ab0e411d43312ae7e74142b788d3e45270cb5c
    HEAD_REF master
    PATCHES
        0001-use-vcpkg-ports.patch
)

vcpkg_find_acquire_program(PERL)
vcpkg_find_acquire_program(PYTHON3)
get_filename_component(PYTHON3_DIR "${PYTHON3}" DIRECTORY)
vcpkg_add_to_path("${PYTHON3_DIR}")

x_vcpkg_get_python_packages(PYTHON_VERSION "3" PACKAGES python-gettext OUT_PYTHON_VAR "PYTHON3")

vcpkg_add_to_path("${CURRENT_INSTALLED_DIR}/tools/gettext")
vcpkg_add_to_path("${CURRENT_INSTALLED_DIR}/tools/glib")

set(enable_viewer "false")
if("viewer" IN_LIST FEATURES)
  set(enable_viewer "true")
endif()

set(enable_gst_plugin "false")
if("gst-plugin" IN_LIST FEATURES)
  set(enable_gst_plugin "true")
endif()

vcpkg_configure_meson(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -Dviewer=${enable_viewer}
        -Dgst-plugin=${enable_gst_plugin}
        -Dpacket-socket=false
        -Dusb=false
        -Dfast-heartbeat=false
        -Ddocumentation=false
        -Dintrospection=false
)

vcpkg_install_meson()
vcpkg_copy_pdbs()

file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/arv-fake-gv-camera-0.8${VCPKG_TARGET_EXECUTABLE_SUFFIX})
file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/arv-tool-0.8${VCPKG_TARGET_EXECUTABLE_SUFFIX})
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/${PORT})
file(RENAME ${CURRENT_PACKAGES_DIR}/bin/arv-fake-gv-camera-0.8${VCPKG_TARGET_EXECUTABLE_SUFFIX} ${CURRENT_PACKAGES_DIR}/tools/${PORT}/arv-fake-gv-camera-0.8${VCPKG_TARGET_EXECUTABLE_SUFFIX})
file(RENAME ${CURRENT_PACKAGES_DIR}/bin/arv-tool-0.8${VCPKG_TARGET_EXECUTABLE_SUFFIX} ${CURRENT_PACKAGES_DIR}/tools/${PORT}/arv-tool-0.8${VCPKG_TARGET_EXECUTABLE_SUFFIX})
vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/${PORT})

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
  file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
