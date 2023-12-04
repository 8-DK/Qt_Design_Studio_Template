#ifndef MAINCONTEXT_H
#define MAINCONTEXT_H

#include <QStandardPaths>
#include <QDir>
#include <QDebug>
#include "imagemodel.h"


class MainContext
{
    static MainContext* instance;

public:
    MainContext();
    static MainContext* getInstance()
    {
        if(instance != nullptr)
            return instance;
        instance = new MainContext();
        return instance;
    }

    ImageModel imageModel;

    QString getStoragePath();
};

#endif // MAINCONTEXT_H
