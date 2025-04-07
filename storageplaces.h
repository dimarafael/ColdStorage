#ifndef STORAGEPLACES_H
#define STORAGEPLACES_H

#include <QAbstractListModel>
#include <QObject>
#include "apiclient.h"
#include "shelves.h"

struct Place{
    int placeId;
    QString name; // place position name
    int shelvesQty; // shelves quanlity
    Shelves* shelves;
};

class StoragePlaces : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit StoragePlaces(QObject *parent = nullptr);
    enum Roles {
        PlaceIdRole = Qt::UserRole + 1,
        NameRole,
        ShelvesQtyRole,
        ShelvesModelRole
    };

    // QAbstractItemModel interface
public:
    virtual int rowCount(const QModelIndex &parent) const override;
    virtual QVariant data(const QModelIndex &index, int role) const override;
    virtual QHash<int, QByteArray> roleNames() const override;

    void loadStoragePlaces();

private:
    QVector<Place> m_places;
    ApiClient api;
};

#endif // STORAGEPLACES_H
