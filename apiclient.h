#ifndef APICLIENT_H
#define APICLIENT_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

namespace Constants {
inline const QString API_BASE_URL = "http://10.0.10.64:8080/api/v2/tables";
inline const QString API_TOKEN = "YGrXneYlcObAqH4VUM9YnC6dAkX25HEkpeSLtg46";
}

class ApiClient : public QObject
{
    Q_OBJECT
public:
    explicit ApiClient(QObject *parent = nullptr);

    void get(const QString &url, std::function<void(QJsonObject)> callback);
    void post(const QString &url, const QJsonObject &data, std::function<void(bool)> callback);
    void del(const QString &url, std::function<void(bool)> callback);

private:
    QNetworkAccessManager m_manager;
};

#endif // APICLIENT_H
