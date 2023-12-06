#include "ImageModel.h"
#include "utils.h"

ImageModel::ImageModel(QObject *parent)
    :QAbstractListModel(parent)
{
    loadImagesFromStorage();
}

void ImageModel::addImage(QString name,QString filePath,int w,int h,QVariantMap data) {
    ImageData* img = new ImageData(name,filePath,w,h,data);
    addImageData(img);
}

ImageModel::~ImageModel()
{
    for (auto it = ImageDataList.begin(); it != ImageDataList.end(); ++it)
    {
        delete it;
    }
}

QVariantMap ImageModel::getImage(QString name) {
    for(int i = 0 ; i < ImageDataList.count() ; i++)
    {
        if(ImageDataList.at(i)->name == name)
        {
            return ImageDataList.at(i)->colorMap;
        }
    }
}

QVariantMap ImageModel::getImage(int index)
{
    return ImageDataList.at(index)->colorMap;
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
    case FilePath:
        return imageData->filePath;
    case Width:
        return imageData->width;
    case Height:
        return imageData->height;
    default:
        return QVariant();
    }
}

bool ImageModel::setData(const QModelIndex &index, const QVariant &value, int role) {

    if (!index.isValid() || index.row() >= ImageDataList.count())
        return false;

    ImageData *imageData = ImageDataList.at(index.row());

    if (index.isValid() && role == Qt::EditRole) {
        switch (role) {
        case NameRole:
            imageData->name = value.toString();
            break;
        case FilePath:
            imageData->filePath = value.toString();
            break;
        case Width:
            imageData->width  = value.toInt();
            break;
        case Height:
            imageData->height = value.toInt();
            break;
        default:
            return false;
        }
        emit dataChanged(index, index);
        return true;
    }
    return false;
}

Qt::ItemFlags ImageModel::flags(const QModelIndex &index) const {
    Qt::ItemFlags defaultFlags = QAbstractListModel::flags(index);
    if (index.isValid())
        return Qt::ItemIsEnabled | Qt::ItemIsSelectable | Qt::ItemIsDragEnabled | Qt::ItemIsDropEnabled;
    else
        return defaultFlags;
}

bool ImageModel::removeRows(int row, int count, const QModelIndex &parent) {
    if (row < 0 || row + count > ImageDataList.size())
        return false;

    beginRemoveRows(parent, row, row + count - 1);
    ImageDataList.removeAt(row);
    endRemoveRows();

    return true;
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
    QString filePath = Utils::getStoragePath()+"/"+fileName+".json";
    QFile file(filePath);
    if(QFile::exists(filePath))
        QFile::remove(filePath);
    if (file.open(QIODevice::WriteOnly)) {
        // Write the JSON document to the file
        file.write(jsonDocument.toJson());
        file.close();
        qDebug() << "ColorMap stored to JSON file:" << fileName;
        ImageData* img = new ImageData(fileName,filePath,width,height,colorMap);
        addImageData(img);
    } else {
        qWarning() << "Failed to open file for writing:" << fileName;
    }
}

void ImageModel::saveThumbImage(QImage img,QString fileName)
{
    QString filePath = Utils::getStoragePath()+"/"+fileName+"_tumb.jpeg";
    if(QFile::exists(filePath))
        QFile::remove(filePath);
    qDebug() << "save image to :" + filePath;
    img.save(filePath);
}

void ImageModel::removeImage(int index,QString fileName)
{
    ImageData *imageData = ImageDataList.at(index);
    QFile::remove(imageData->filePath);
    QFile::remove(Utils::getStoragePath()+"/"+imageData->name+"_tumb.jpeg");
    delete imageData;
    removeRows(index,1);
}

void ImageModel::loadImagesFromStorage()
{
    QString storagePath = Utils::getStoragePath();
    // Create a QDir object with the specified path
    QDir dir(storagePath);

    // Set a filter to list only files
    dir.setFilter(QDir::Files);

    // Set a name filter to include only JSON files
    dir.setNameFilters(QStringList() << "*.json");

    // Get the list of files in the directory
    QStringList fileList = dir.entryList();

    // Iterate through the list and print the file names
    foreach(const QString &fileName, fileList) {
        QString fileFullPath = storagePath+"/"+fileName;
        qDebug() << "JSON File:" << fileFullPath;
        // Read the JSON file
        QFile file(fileFullPath);
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            qDebug() << "Error opening file:" << file.errorString();
            return;
        }

        // Read the contents of the file
        QByteArray jsonData = file.readAll();
        file.close();

        // Parse the JSON data
        QJsonDocument jsonDoc = QJsonDocument::fromJson(jsonData);
        if (jsonDoc.isNull()) {
            qDebug() << "Failed to parse JSON";
            return;
        }

        // Access the root object
        QJsonObject rootObject = jsonDoc.object();

        // Access individual values
        QString name = rootObject["name"].toString();
        int width = rootObject["width"].toInt();
        int height = rootObject["height"].toInt();
        QString version = rootObject["version"].toString();

        qDebug() << "Name:" << name;
        qDebug() << "Width:" << width;
        qDebug() << "Height:" << height;
        qDebug() << "Version:" << version;

        // Access the "colorMap" array
        QJsonArray colorMapArray = rootObject["colorMap"].toArray();

        QVariantMap data;
        // Iterate through the array
        for (const QJsonValue &colorMapValue : colorMapArray) {
            QJsonObject colorMapObject = colorMapValue.toObject();
            QString color = colorMapObject["color"].toString();
            QString index = colorMapObject["index"].toString();
            data.insert(index,color);
            qDebug() << "Color:" << color << "Index:" << index;
        }
        ImageData* img = new ImageData(name,fileFullPath,width,height,data);
        addImageData(img);
    }
}

bool ImageModel::moveImageUp(int index)
{
    int fromRow = index;
    int toRow = index-1;
    if (fromRow < 0 || fromRow >= ImageDataList.size() || toRow < 0 || toRow >= ImageDataList.size())
        return false;

    beginMoveRows(QModelIndex(), fromRow, fromRow, QModelIndex(), toRow > fromRow ? toRow + 1 : toRow);
    ImageDataList.move(fromRow, toRow);
    endMoveRows();

    return true;
}


bool ImageModel::moveImageDown(int index)
{
    int fromRow = index;
    int toRow = index+1;
    if (fromRow < 0 || fromRow >= ImageDataList.size() || toRow < 0 || toRow >= ImageDataList.size())
        return false;

    beginMoveRows(QModelIndex(), fromRow, fromRow, QModelIndex(), toRow > fromRow ? toRow + 1 : toRow);
    ImageDataList.move(fromRow, toRow);
    endMoveRows();

    return true;
}

QString ImageModel::getFileName(int index)
{
    return ImageDataList.at(index)->name;
}

QString ImageModel::getFilePath(int index)
{
    return ImageDataList.at(index)->filePath;
}

int ImageModel::getWidth(int index)
{
    return ImageDataList.at(index)->width;
}

int ImageModel::getHeight(int index)
{
    return ImageDataList.at(index)->height;
}

QVariantMap ImageModel::getCanvas(int index)
{
    return ImageDataList.at(index)->colorMap;
}
