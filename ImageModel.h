#ifndef ImageModel_H
#define ImageModel_H
#include <QAbstractListModel>
#include <QObject>
#include <QVariantMap>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QImage>

struct ImageData {
    QString name;
    int width;
    int height;
    QStringList data;
    ImageData(QString n, int w,int h, QStringList d)
    {
        name = n;
        width = w;
        height = h;
            data =d;
    }
    // Add other relevant data members as needed
};

class ImageModel : public QAbstractListModel
{
    Q_OBJECT
    QList<ImageData*> ImageDataList;
public:
    enum ImageDataRoles {
        NameRole = Qt::UserRole + 1,
        Width,
        Height,
        Data
    };
    ImageModel(QObject *parent = nullptr);
    QHash<int, QByteArray> roleNames() const override{
        QHash<int, QByteArray> roles;
        roles[NameRole] = "name";
        roles[Width] = "width";
        roles[Height] = "height";
        roles[Data] = "data";
        return roles;
    }

    void addImageData(ImageData *newImageData);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;



public slots:
    Q_INVOKABLE void addImage(QString name,int w,int h,QStringList data);
    Q_INVOKABLE QStringList getImage(QString name);
    Q_INVOKABLE void saveImage(QString name,int w,int h,const QVariantMap &colorMap);
    Q_INVOKABLE void receiveColorMap(const QVariantMap &colorMap);
    Q_INVOKABLE void saveThumbImage(QImage img,QString fileName);
};

#endif // ImageModel_H
