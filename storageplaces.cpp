#include "storageplaces.h"

StoragePlaces::StoragePlaces(QObject *parent)
    :QAbstractListModel{parent}
{
    loadStoragePlaces();
}

int StoragePlaces::rowCount(const QModelIndex &parent) const
{
    return m_places.size();
}

QVariant StoragePlaces::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_places.size())
        return QVariant();

    const auto &place = m_places[index.row()];

    switch(role){
    case PlaceIdRole: return place.placeId;
    case NameRole: return place.name;
    case ShelvesQtyRole: return place.shelvesQty;
    case ShelvesModelRole: return QVariant::fromValue(place.shelves);
    }

    return QVariant();
}

QHash<int, QByteArray> StoragePlaces::roleNames() const
{
    return {
        {PlaceIdRole, "placeId"},
        {NameRole, "placeName"},
        {ShelvesQtyRole,"shelvesQty"},
        {ShelvesModelRole,"shelvesModel"}
    };
}

void StoragePlaces::loadStoragePlaces()
{
    api.get("/storage_places", [this](QJsonArray jsonArray) {
        beginResetModel();
        m_places.clear();
        for (const auto &item : jsonArray) {
            QJsonObject obj = item.toObject();
            int placeId = obj["id"].toInt();
            int shelvesQty = obj["shelves"].toInt();
            Shelves* shelves = new Shelves(this, shelvesQty, placeId);
            shelves->loadShelves();
            m_places.append({
                placeId,
                obj["name"].toString(),
                shelvesQty,
                shelves
            });
        }
        endResetModel();
    });
}
