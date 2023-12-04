#include "ImageModel.h"
#include "maincontext.h"

ImageModel::ImageModel(QObject *parent)
    :QAbstractListModel(parent)
{

}

void ImageModel::addImage(QString name,int w,int h,QStringList data) {
    ImageData* img = new ImageData(name,w,h,data);
    addImageData(img);
}

QStringList ImageModel::getImage(QString name) {
    for(int i = 0 ; i < ImageDataList.count() ; i++)
    {
        if(ImageDataList.at(i)->name == name)
        {
            return ImageDataList.at(i)->data;
        }
    }
}

void ImageModel::addImageData(ImageData *newImageData) {
    // Insert a new row at the end of the model
    int newRow = rowCount();

    // Begin inserting a new row
    beginInsertRows(QModelIndex(), newRow, newRow);

    // Add the new data to the list
    ImageDataList.append(newImageData);

    // End inserting the new row
    endInsertRows();
}

int ImageModel::rowCount(const QModelIndex &parent) const {
    Q_UNUSED(parent);
    // Return the number of items in your data
    return ImageDataList.count();
}

QVariant ImageModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= ImageDataList.count())
        return QVariant();

    ImageData *imageData = ImageDataList.at(index.row());

    switch (role) {
    case NameRole:
        return imageData->name;
    case Width:
        return imageData->width;
    case Height:
        return imageData->height;
    default:
        return QVariant();
    }
}

void ImageModel::saveImage(QString fileName,int width,int height,const QVariantMap &colorMap)
{
    // Create a JSON object to store the information
    QJsonObject jsonObj;
    jsonObj["name"] = fileName;
    jsonObj["height"] = height;
    jsonObj["width"] = width;
    jsonObj["version"] = "1.0";

    // Create a JSON array to store colorMap
    QJsonArray colorArray;
    for (auto it = colorMap.begin(); it != colorMap.end(); ++it) {
        QJsonObject colorObject;
        colorObject["index"] = it.key();
        colorObject["color"] = it.value().toString();
        colorArray.append(colorObject);
    }

    jsonObj["colorMap"] = colorArray;

    // Convert the JSON object to a JSON document
    QJsonDocument jsonDocument(jsonObj);

    // Open the file for writing
    QFile file(MainContext::getInstance()->getStoragePath()+"/"+fileName+".json");
    if (file.open(QIODevice::WriteOnly)) {
        // Write the JSON document to the file
        file.write(jsonDocument.toJson());
        file.close();
        qDebug() << "ColorMap stored to JSON file:" << fileName;
    } else {
        qWarning() << "Failed to open file for writing:" << fileName;
    }
}

void ImageModel::saveThumbImage(QImage img,QString fileName)
{
    qDebug() << "save image to :" + MainContext::getInstance()->getStoragePath()+"/"+fileName;
    img.save(MainContext::getInstance()->getStoragePath()+"/"+fileName);
}

void ImageModel::receiveColorMap(const QVariantMap &colorMap)
{
    qDebug() << "Received Color Map:";
    for (auto it = colorMap.begin(); it != colorMap.end(); ++it) {
        qDebug() << "Index:" << it.key() << "Color:" << it.value().toString();
    }
}

