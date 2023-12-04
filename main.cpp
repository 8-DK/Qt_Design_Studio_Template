#include "main.h"
#include "maincontext.h"



int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    int ret_code = 0;

    app.setOrganizationName("MatSmily");
    app.setOrganizationDomain("MatSmily");

    QRect screenGeometry = QGuiApplication::primaryScreen()->geometry();
    int screenWidth = screenGeometry.width();
    int screenHeight = screenGeometry.height();

    engine.rootContext()->setContextProperty("appW",screenWidth);
    engine.rootContext()->setContextProperty("appH",screenHeight);
    engine.rootContext()->setContextProperty("GImageDataModel", &MainContext::getInstance()->imageModel);

    engine.addImportPath("qrc:/content");
    engine.addImportPath("qrc:/imports");

    QPixmap pixmap(":/splash.png");
    QSplashScreen splash(pixmap);
    splash.show();

    engine.load(QUrl(QStringLiteral("qrc:/content/App.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;
    QObject *rootObj = nullptr;
    rootObj = engine.rootObjects().at(engine.rootObjects().count()-1);
    QQuickWindow *w = qobject_cast<QQuickWindow*>(rootObj);
    w->setFlags(Qt::Window);
//    w->setMinimumSize(QSize(800,500));
    ret_code = app.exec();
    splash.close();
    return ret_code;
}
