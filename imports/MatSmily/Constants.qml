pragma Singleton
import QtQuick 6.5
//import QtQuick.Studio.Application

QtObject {
    property bool isMobile: (Qt.platform.os === "android")
    property int width:  411
    property int height: 833
    property int multFact: 1
//        property int width:  Screen.desktopAvailableWidth
//        property int height: Screen.desktopAvailableHeight

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

    property variant get : (Qt.platform.os === "android") ? androidDef : androidDef

    property variant androidDef:    {
        'backgroundColor'   : "#ffffff",
        'width'             : Screen.desktopAvailableHeight,
        'height'            : Screen.desktopAvailableWidth,
        'textBoxW'          : width * 0.1,
        'textBoxH'          : height * 0.05,
        'thmBoarderColor'   : "#6D5D6E",
        'thmBgPrimaryColor' : "#ffffff",
        'thmBgSecondaryColor' : "#786fa6",
        'thmDefBoxRadius'   : multFact * 5,
        'thmDefBoxBorderWidth' : multFact * 1,
        'buttonW'           :  width * 0.4,
        'buttonH'           :  height * 0.07
    }
    property variant deskstopDef:   {   'backgroundColor'   : "#ffffff",
        'width'             : Screen.desktopAvailableWidth,
        'height'            : Screen.desktopAvailableHeight,
        'textBoxW'          : width * 0.1,
        'textBoxH'          : height * 0.05,
        'thmBoarderColor'   : "#546de5",
        'thmBgPrimaryColor' : "#63cdda",
        'thmBgSecondaryColor' : "#786fa6",
        'thmDefBoxRadius'   : multFact * 5,
        'thmDefBoxBorderWidth' : multFact * 1,
        'buttonW'           :  width * 0.4,
        'buttonH'           :  height * 0.07
    }

    //    property StudioApplication application: StudioApplication {
    //        fontPath: Qt.resolvedUrl("../../content/" + relativeFontDirectory)
    //    }
}
