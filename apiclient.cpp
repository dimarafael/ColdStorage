#include "apiclient.h"

ApiClient::ApiClient(QObject *parent)
    : QObject{parent}
{}

void ApiClient::get(const QString &endpoint, std::function<void(QJsonObject)> callback) {
    QNetworkRequest request((QUrl(Constants::API_BASE_URL + endpoint)));
    request.setRawHeader("xc-token", Constants::API_TOKEN.toUtf8());

    auto reply = m_manager.get(request);

    connect(reply, &QNetworkReply::finished, this, [this, reply, callback]() {
        if (reply->error() == QNetworkReply::NoError) {
            QJsonObject jsonObject = QJsonDocument::fromJson(reply->readAll()).object();
            callback(jsonObject);
            // QJsonArray jsonArray = QJsonDocument::fromJson(reply->readAll()).array();
            // callback(jsonArray);
        } else {
            qDebug() << "API error: " << reply->errorString() + " URL: " << reply->url();
        }
        reply->deleteLater();
    });
}

void ApiClient::post(const QString &endpoint, const QJsonObject &data, std::function<void(bool)> callback) {
    QNetworkRequest request((QUrl(Constants::API_BASE_URL + endpoint)));
    request.setRawHeader("xc-token", Constants::API_TOKEN.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    auto reply = m_manager.post(request, QJsonDocument(data).toJson());

    connect(reply, &QNetworkReply::finished, this, [this, reply, callback]() {
        callback(reply->error() == QNetworkReply::NoError);
        reply->deleteLater();
    });
}

void ApiClient::del(const QString &endpoint, std::function<void(bool)> callback) {
    QNetworkRequest request((QUrl(Constants::API_BASE_URL + endpoint)));
    request.setRawHeader("xc-token", Constants::API_TOKEN.toUtf8());
    auto reply = m_manager.deleteResource(request);

    connect(reply, &QNetworkReply::finished, this, [this, reply, callback]() {
        callback(reply->error() == QNetworkReply::NoError);
        reply->deleteLater();
    });
}
