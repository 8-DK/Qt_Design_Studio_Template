pragma Singleton
import QtQuick 6.5
//import QtQuick.Studio.Application

QtObject {
    property bool isMobile: (Qt.platform.os === "android")
    property int width:  720
    property int height: 1280
//    property int width:  Screen.desktopAvailableWidth
//    property int height: Screen.desktopAvailableHeight

    property string relativeFontDirectory: "fonts"

    /* Edit this comment to add your custom font */
    readonly property font font: Qt.font({
                                             family: Qt.application.font.family,
                                             pixelSize: Qt.application.font.pixelSize
                                         })
    readonly property font largeFont: Qt.font({
                                                  family: Qt.application.font.family,
                                                  pixelSize: Qt.application.font.pixelSize * 1.6
                                              })

    property variant get : (Qt.platform.os === "android") ? androidDef : deskstopDef

    property variant androidDef:    {
                                        'backgroundColor'   : "#c2c2c2",
                                        'width'             : Screen.desktopAvailableHeight,
                                        'height'            : Screen.desktopAvailableWidth
                                    }
    property variant deskstopDef:   {   'backgroundColor'   : "#0c1154",
                                        'width'             : Screen.desktopAvailableWidth,
                                        'height'            : Screen.desktopAvailableHeight
                                    }

//    property StudioApplication application: StudioApplication {
//        fontPath: Qt.resolvedUrl("../../content/" + relativeFontDirectory)
//    }
}
