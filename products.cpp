#include "products.h"

Products &Products::getInstance()
{
    static Products instance;
    return instance;
}

void Products::loadProducts()
{
    api.get("/mt5c43cjt40an63/records?limit=100", [this](const QJsonObject &response) {
        beginResetModel();
        m_products.clear();

        QJsonArray listArray = response["list"].toArray();

        for (const auto &item : listArray) {
            QJsonObject obj = item.toObject();
            m_products.append({
                obj["id"].toInt(),
                obj["name"].toString(),
                obj["code"].toInt(),
                static_cast<float>(obj["stage1Hours"].toDouble()),
                static_cast<float>(obj["stage2Hours"].toDouble()),
                static_cast<float>(obj["stage3Hours"].toDouble())
            });
        }

        endResetModel();
    });
}

Product Products::getProductById(int id) const
{
    for (const Product &product : m_products) {
        if (product.id == id)
            return product;
    }

    Product notFound{};
    notFound.id = -1;
    return notFound;
}

QString Products::getProductNameById(int id)
{
    return getProductById(id).name;
}

void Products::removeProduct(int id)
{
    QJsonObject data;
    data["id"] = id;

    api.del("/mt5c43cjt40an63/records", data, [this](bool success) {
        if (success) {
            this->loadProducts();
            qDebug() << "Product deleted";
        } else {
            qDebug() << "Error in deleting the product";
        }
    });
}

void Products::addProduct(int code, QString name, float stage1Hours, float stage2Hours, float stage3Hours)
{
    // qDebug() << " Add product: " << code << " : " << name << " : " << stage1Hours << " : " << stage2Hours << " : " << stage3Hours;

    QJsonObject data;

    data["code"] = code;
    data["name"] = name;
    data["stage1Hours"] = stage1Hours;
    data["stage2Hours"] = stage2Hours;
    data["stage3Hours"] = stage3Hours;

    api.post("/mt5c43cjt40an63/records", data, [this](bool success) {
        if (success) {
            this->loadProducts();
            // qDebug() << "Record added in shelf_products";
        } else {
            qDebug() << "Error in adding the record in products";
        }
    });
}

void Products::modifyProduct(int id, int code, QString name, float stage1Hours, float stage2Hours, float stage3Hours)
{
    QJsonObject data;

    data["id"] = id;
    data["code"] = code;
    data["name"] = name;
    data["stage1Hours"] = stage1Hours;
    data["stage2Hours"] = stage2Hours;
    data["stage3Hours"] = stage3Hours;

    api.patch("/mt5c43cjt40an63/records", data, [this](bool success) {
        if (success) {
            this->loadProducts();
            // qDebug() << "Record added in shelf_products";
        } else {
            qDebug() << "Error in midification the record in products";
        }
    });
}

Products::Products(QObject *parent)
    : QAbstractListModel{parent}
{
    loadProducts();
}

int Products::rowCount(const QModelIndex &parent) const
{
    return m_products.count();
}

QVariant Products::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_products.size())
        return QVariant();

    const auto &product = m_products[index.row()];

    switch(role){
    case IdRole:
        return product.id;
    case NameRole:
        return product.name;
    case CodeRole:
        return product.code;
    case Stage1HoursRole:
        return product.stage1Hours;
    case Stage2HoursRole:
        return product.stage2Hours;
    case Stage3HoursRole:
        return product.stage3Hours;
    }

    return QVariant();
}

QHash<int, QByteArray> Products::roleNames() const
{
    return {
        {IdRole, "productId"},
        {NameRole,"productName"},
        {CodeRole,"productCode"},
        {Stage1HoursRole,"stage1Hours"},
        {Stage2HoursRole,"stage2Hours"},
        {Stage3HoursRole,"stage3Hours"}
    };
}
