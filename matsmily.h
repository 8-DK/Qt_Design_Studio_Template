#ifndef MATSMILY_H
#define MATSMILY_H
#include <QtQml/qqmlregistration.h>
#include <QObject>

class MatSmily: public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    MatSmily(QObject* parent=nullptr);
    MatSmily(){}
};

#endif // MATSMILY_H
