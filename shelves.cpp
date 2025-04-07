#include "shelves.h"

Shelves::Shelves(QObject *parent, int quantity, int placeId)
    : QAbstractListModel{parent}
{
    m_placeId = placeId;
    for (int i = 0; i < quantity; ++i) {
        m_shelves.append({false, // ocupated
                          0, // productId
                          QDateTime::currentDateTime(), // timeStamp
                          0, // stage
                          0}); // progress
    }
}

void Shelves::loadShelves()
{
    api.get(QString("/shelves?storage_place_id=%1").arg(m_placeId), [this](QJsonArray jsonArray) {
        for(int i=0; i < m_shelves.size(); i++){
            m_shelves[i].ocupated = false;
        }
        beginResetModel();
        for (const auto &item : jsonArray) {
            QJsonObject obj = item.toObject();
            int shelf = obj["shelf"].toInt();
            bool ocupated = !obj["product_id"].isNull();
            int productId= ocupated ? obj["product_id"].toInt() : 0;
            QDateTime timeStamp = QDateTime::fromString( obj["placedAt"].toString(), Qt::ISODate );

            if(shelf >= 0 && shelf < m_shelves.size()){
                m_shelves[shelf].ocupated = ocupated;
                m_shelves[shelf].productId = productId;
                m_shelves[shelf].timeStamp = timeStamp;
                m_shelves[shelf].stage = ocupated ? calculateStage(productId, timeStamp) : -1;
                m_shelves[shelf].progress = ocupated ? calculateProgress(productId, timeStamp) : 0;
            }
        }
        endResetModel();
    });
}

int Shelves::rowCount(const QModelIndex &parent) const
{
    return m_shelves.count();
}

QVariant Shelves::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_shelves.size())
        return QVariant();

    const auto &shelf = m_shelves[index.row()];

    switch(role){
    case OcupatedRole:
        return shelf.ocupated;
    case ProductIdRole:
        return shelf.productId;
    case TimeStampRole:
        return shelf.timeStamp;
    case StageRole:
        return shelf.stage;
    case StageProgress:
        return shelf.progress;
    }

    return QVariant();
}

QHash<int, QByteArray> Shelves::roleNames() const
{
    return {
        {OcupatedRole, "ocupated"},
        {ProductIdRole,"productId"},
        {TimeStampRole,"timeStamp"},
        {StageRole,"stage"},
        {StageProgress,"progress"}
    };
}

int Shelves::calculateStage(int productId, QDateTime startTimeStamp)
{
    return productId;
}

float Shelves::calculateProgress(int productId, QDateTime startTimeStamp)
{
    return 0.5;
}

