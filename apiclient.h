#ifndef APICLIENT_H
#define APICLIENT_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

namespace Constants {
inline const QString API_BASE_URL = "http://10.0.10.64:1880/coldstorage";
}

class ApiClient : public QObject
{
    Q_OBJECT
public:
    explicit ApiClient(QObject *parent = nullptr);

    void get(const QString &url, std::function<void(QJsonArray)> callback);
    void post(const QString &url, const QJsonObject &data, std::function<void(bool)> callback);
    void del(const QString &url, std::function<void(bool)> callback);

private:
    QNetworkAccessManager m_manager;
};

#endif // APICLIENT_H
