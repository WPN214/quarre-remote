QT += quick sensors multimedia network
CONFIG += c++11 localmod

android: {
    QT += androidextras
    DEFINES += ANDROID
}

QML_IMPORT_PATH = $$QML_MODULE_DESTDIR

SOURCES += main.cpp
SOURCES += source/system.cpp
SOURCES += source/audio.cpp

HEADERS += source/system.hpp
HEADERS += source/audio.hpp

RESOURCES +=                        \
    resources/qml/qml.qrc           \
    resources/images/images.qrc     \
    resources/fonts/fonts.qrc


# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
