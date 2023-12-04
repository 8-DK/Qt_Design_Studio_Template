#include "maincontext.h"

MainContext* MainContext::instance = nullptr;

MainContext::MainContext()
{

}

QString MainContext::getStoragePath()
{
    QString androidFolderPath(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/MatSmiley");
    QDir androidHomePath(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation));
    QDir* dir=new QDir(androidFolderPath);
    if (!dir->exists()) {
        qWarning("creating new folder");
        dir->mkpath(".");
    }
    return dir->absolutePath();
}
