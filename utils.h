#ifndef UTILS_H
#define UTILS_H


#include <QStandardPaths>
#include <QDir>
#include <QString>

class Utils
{
public:
    Utils();
    static QString getStoragePath();
};

#endif // UTILS_H
