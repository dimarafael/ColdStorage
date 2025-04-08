#ifndef SHELVES_H
#define SHELVES_H

#include <QAbstractListModel>
#include <QObject>
#include <QDateTime>
#include "apiclient.h"
#include "products.h"

struct Shelf{
    bool ocupated;
    int productId;
    QDateTime timeStamp;
    int stage;
    float progress;
    QString elapsed;
};

class Shelves : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit Shelves(QObject *parent = nullptr, int quantity = 0, int placeId = 0);
    enum Roles{
        OcupatedRole = Qt::UserRole + 1,
        ProductIdRole,
        TimeStampRole,
        StageRole,
        StageProgressRole,
        ElapsedRole
    };

    void loadShelves();

    // QAbstractItemModel interface
public:
    virtual int rowCount(const QModelIndex &parent) const override;
    virtual QVariant data(const QModelIndex &index, int role) const override;
    virtual QHash<int, QByteArray> roleNames() const override;

private:
    int m_placeId;
    QVector<Shelf> m_shelves;
    ApiClient api;
    Products &products = Products::getInstance();

    int calculateStage(int productId, QDateTime startTimeStamp);
    float calculateProgress(int productId, QDateTime startTimeStamp);
    float hoursElapsed(const QDateTime &pastTime);
    QString getElapsedText(const QDateTime &startTimeStamp);
};

#endif // SHELVES_H
