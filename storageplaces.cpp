#include "storageplaces.h"

StoragePlaces::StoragePlaces(QObject *parent)
    :QAbstractListModel{parent}
{

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
    case NameRole: return place.name;
    case ShelvesQtyRole: return place.shelvesQty;
    }

    return QVariant();
}

QHash<int, QByteArray> StoragePlaces::roleNames() const
{
    return {
        {NameRole, "placeName"},
        {ShelvesQtyRole,"shelvesQty"}
    };
}
