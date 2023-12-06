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
    QString filePath;
    int width;
    int height;
    QVariantMap colorMap;
    ImageData(QString n,QString p, int w,int h, QVariantMap d)
    {
        name = n;
        filePath = p;
        width = w;
        height = h;
        colorMap = d;
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
        FilePath,
        Width,
        Height,
        Data
    };
    ImageModel(QObject *parent = nullptr);
    ~ImageModel();
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
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;
    void loadImagesFromStorage();


public slots:
    Q_INVOKABLE void addImage(QString name,QString filePath, int w,int h,QVariantMap data);
    Q_INVOKABLE QVariantMap getImage(QString name);
    Q_INVOKABLE QVariantMap getImage(int index);
    Q_INVOKABLE void saveImage(QString name,int w,int h,const QVariantMap &colorMap);
    Q_INVOKABLE void saveThumbImage(QImage img,QString fileName);
    Q_INVOKABLE void removeImage(int index,QString fileName="");
    Q_INVOKABLE bool moveImageUp(int index);
    Q_INVOKABLE bool moveImageDown(int index);

    Q_INVOKABLE QString getFileName(int index);
    Q_INVOKABLE QString getFilePath(int index);
    Q_INVOKABLE int getWidth(int index);
    Q_INVOKABLE int getHeight(int index);
    Q_INVOKABLE QVariantMap getCanvas(int index);
};

#endif // ImageModel_H
