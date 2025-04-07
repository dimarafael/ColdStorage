#ifndef PRODUCTS_H
#define PRODUCTS_H

#include <QAbstractListModel>
#include <QObject>
#include "apiclient.h"

struct Product
{
    int id;
    QString name;
    int code;
    float stage1Hours;
    float stage2Hours;
    float stage3Hours;
};

class Products : public QAbstractListModel
{
    Q_OBJECT
public:
    //for singleton
    static Products& getInstance();

    Products(const Products&) = delete;
    Products& operator=(const Products&) = delete;

    enum Roles{
        IdRole = Qt::UserRole + 1,
        NameRole,
        CodeRole,
        Stage1HoursRole,
        Stage2HoursRole,
        Stage3HoursRole
    };

    void loadProducts();

    Q_INVOKABLE Product getProductById(int id) const;

    // QAbstractItemModel interface
public:
    virtual int rowCount(const QModelIndex &parent) const override;
    virtual QVariant data(const QModelIndex &index, int role) const override;
    virtual QHash<int, QByteArray> roleNames() const override;

private:
    QVector<Product> m_products;
    explicit Products(QObject *parent = nullptr);
    ApiClient api;
};

#endif // PRODUCTS_H
