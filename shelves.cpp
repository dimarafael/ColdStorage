#include "shelves.h"

Shelves::Shelves(QObject *parent, int quantity, int placeId)
    : QAbstractListModel{parent}
{
    m_placeId = placeId;
    for (int i = 0; i < quantity; ++i) {
        m_shelves.append({false,0,QDateTime::currentDateTime()});
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

            if(shelf >= 0 && shelf < m_shelves.size()){
                m_shelves[shelf].ocupated = ocupated;
                m_shelves[shelf].productId = ocupated? obj["product_id"].toInt() : 0;
                m_shelves[shelf].timeStamp = QDateTime::fromString( obj["placedAt"].toString(), Qt::ISODate );
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
    }

    return QVariant();
}

QHash<int, QByteArray> Shelves::roleNames() const
{
    return {
        {OcupatedRole, "ocupated"},
        {ProductIdRole,"productId"},
        {TimeStampRole,"timeStamp"}
    };
}
