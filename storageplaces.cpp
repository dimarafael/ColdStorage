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
    api.get("/mcxfry38i1fftgm/records?limit=100", [this](QJsonObject jsonResponse) {
        beginResetModel();
        m_places.clear();

        QJsonArray listArray = jsonResponse["list"].toArray();

        for (const auto &item : listArray) {
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

        qDebug() << "loadStoragePlaces: size=" << m_places.size();

        endResetModel();
    });
}
