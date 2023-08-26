QT += quick
QT += widgets sql
QT += qml quick
QT += gui
QT += core
QT += network
QT += xml
QT += svg
QT += texttospeech
QT += multimedia
QT += core-private
QT += multimedia
QT += opengl
QT += concurrent
QT += quickwidgets
QT += sql
QT += multimediawidgets
QT += websockets
QT += charts
QT += bluetooth

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++17

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

QML_IMPORT_PATH +=  $$PWD/imports/ \
                    $$PWD/content/ \
                    C:/Qt5.14/Tools/QtDesignStudio/bin/qml/QtQuick

# Linux specific instructions
unix:!symbian:!android {
    DEFINES += __Linux__
}

#Win specific code
win32 {
    QMAKE_CXXFLAGS_WARN_OFF -= -Wunused-parameter
    DEFINES += __Win__
#    RC_FILE = App.rc
#    RC_ICONS +=  assets\app_icon.ico
    QTPLUGIN += /plugins
    QMAKE_LFLAGS += -Wl,--rpath=\$$ORIGIN/lib
}

android {
    DEFINES += __android__
    CONFIG += AndroidBuild MobileBuild
    ANDROID_PACKAGE_SOURCE_DIR = \
        $$PWD/android

    include(android/android.pri)
}

INCLUDEPATH += $$PWD

SOURCES += \
    main.cpp

HEADERS += \
    main.h

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

RESOURCES += \
    qml.qrc

