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
                          0, // progress
                          0}); // elapsed
    }
    m_timerRecalculateShelves = new QTimer(this);
    m_timerRecalculateShelves->setInterval(60000);
    connect(m_timerRecalculateShelves, &QTimer::timeout, this, &Shelves::recalculateShelves);
    m_timerRecalculateShelves->start();
}

void Shelves::loadShelves()
{
    api.get(QString("/mgr4ysvay4dj1nr/records?where=(place_id,eq,%1)").arg(m_placeId), [this](QJsonObject response) {
        for(int i=0; i < m_shelves.size(); i++){
            m_shelves[i].ocupated = false;
        }

        beginResetModel();

        QJsonArray listArray = response["list"].toArray();

        for (const auto &item : listArray) {
            QJsonObject obj = item.toObject();
            int shelf = obj["shelf"].toInt();
            bool ocupated = !obj["product_id"].isNull();
            int productId = ocupated ? obj["product_id"].toInt() : 0;
            QDateTime timeStamp = QDateTime::fromString(obj["placedAt"].toString(), Qt::ISODate);

            if(shelf >= 0 && shelf < m_shelves.size()){
                m_shelves[shelf].ocupated = ocupated;
                m_shelves[shelf].productId = productId;
                m_shelves[shelf].timeStamp = timeStamp;
                m_shelves[shelf].stage = ocupated ? calculateStage(productId, timeStamp) : -1;
                m_shelves[shelf].progress = ocupated ? calculateProgress(productId, timeStamp) : 0;
                m_shelves[shelf].elapsed = ocupated ? getElapsedText(timeStamp) : 0;
            }
        }

        endResetModel();
    });
}

void Shelves::putProduct(int shelf, int productId)
{
    qDebug() << "Put Product on place=" << m_placeId << "shelf=" << shelf << " productId=" << productId;
}

void Shelves::takeProduct(int shelf)
{
    qDebug() << "Take from place=" << m_placeId << " shelf=" << shelf;
    beginResetModel();
    m_shelves[shelf].ocupated = false;
    endResetModel();
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
    case StageProgressRole:
        return shelf.progress;
    case ElapsedRole:
        return shelf.elapsed;
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
        {StageProgressRole,"progress"},
        {ElapsedRole,"elapsed"}
    };
}

int Shelves::calculateStage(int productId, const QDateTime &startTimeStamp)
{
    Product product = products.getProductById(productId);
    int stage = 0;

    if (product.id >= 0){
        float elapsed = hoursElapsed(startTimeStamp);
        if (elapsed > product.stage1Hours) stage = 1;
        if (elapsed > product.stage2Hours) stage = 2;
        if (elapsed > product.stage3Hours) stage = 3;
    }

    return stage;
}

float Shelves::calculateProgress(int productId, const QDateTime &startTimeStamp)
{
    Product product = products.getProductById(productId);
    float progress = 0;

    if (product.id >= 0){
        float elapsed = hoursElapsed(startTimeStamp);
        if (elapsed <= product.stage1Hours){
            progress = elapsed / product.stage1Hours;
        } else if (elapsed > product.stage1Hours && elapsed <= product.stage2Hours){
            progress = elapsed / (product.stage2Hours - product.stage1Hours);
        }  else if (elapsed > product.stage2Hours && elapsed <= product.stage3Hours){
            progress = elapsed / (product.stage3Hours - product.stage2Hours);
        }  else if (elapsed > product.stage3Hours){
            progress = 1;
        }
    }

    return progress;
}

float Shelves::hoursElapsed(const QDateTime &pastTime)
{
    return pastTime.secsTo(QDateTime::currentDateTime()) / 3600.0;
}

QString Shelves::getElapsedText(const QDateTime &startTimeStamp)
{
    QDateTime currentTime = QDateTime::currentDateTime();
    qint64 secs = startTimeStamp.secsTo(currentTime);

    int days = secs / 86400;
    secs %= 86400;
    int hours = secs / 3600;
    secs %= 3600;
    int minutes = secs / 60;

    return QString("%1d %2h %3m").arg(days).arg(hours).arg(minutes);
}

void Shelves::recalculateShelves()
{
    beginResetModel();
    for(int shelf = 0; shelf < m_shelves.size(); shelf++){
        if(m_shelves[shelf].ocupated){
            int productId = m_shelves[shelf].productId;
            QDateTime timeStamp = m_shelves[shelf].timeStamp;

            m_shelves[shelf].stage = calculateStage(productId, timeStamp);
            m_shelves[shelf].progress = calculateProgress(productId, timeStamp);
            m_shelves[shelf].elapsed = getElapsedText(timeStamp);
        }
    }
    endResetModel();
}

