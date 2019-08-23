cmake_minimum_required(VERSION 3.1)

project(quarre-remote LANGUAGES C CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 REQUIRED COMPONENTS Core Quick Sensors Multimedia)
if(ANDROID)
    find_package(Qt5 REQUIRED COMPONENTS AndroidExtras)
endif()

add_subdirectory(external/WPN114-network)

set(QUARRE_REMOTE_SOURCES
    main.cpp
    source/system.hpp
    source/system.cpp
    resources/qml/qml.qrc)

add_executable(${PROJECT_NAME} ${QUARRE_REMOTE_SOURCES})
target_compile_definitions(${PROJECT_NAME} PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::Core Qt5::Quick Qt5::Sensors Qt5::Multimedia)

if(ANDROID)
    target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::AndroidExtras)
endif()
