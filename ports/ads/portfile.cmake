vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Beckhoff/ADS
    REF 5b68f80457dc0703cf92c84c4cd2bf418b132929
    SHA512 a2c5ab9c2605e032a4ce7cfb2242d15a6d3c79822f7cbf3ba9fdc470b5844c107bd3192c37594fddf77de65a7e72264fd221d1e2da4a9f2207a9785ac2770fd1
    HEAD_REF master
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_build()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/ads" RENAME copyright)
