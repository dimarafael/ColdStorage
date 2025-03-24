#ifndef STORAGEPLACES_H
#define STORAGEPLACES_H

#include <QAbstractListModel>
#include <QObject>
#include "apiclient.h"

struct Place{
    QString name; // place position name
    int shelvesQty; // shelves quanlity
};

class StoragePlaces : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit StoragePlaces(QObject *parent = nullptr);
    enum Roles {
        NameRole = Qt::UserRole + 1,
        ShelvesQtyRole
    };

    // QAbstractItemModel interface
public:
    virtual int rowCount(const QModelIndex &parent) const override;
    virtual QVariant data(const QModelIndex &index, int role) const override;
    virtual QHash<int, QByteArray> roleNames() const override;

private:
    QVector<Place> m_places;
    ApiClient api;
};

#endif // STORAGEPLACES_H
