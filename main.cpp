#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "storageplaces.h"

Q_DECLARE_METATYPE(Shelves*)

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QGuiApplication app(argc, argv);

    QLocale::setDefault(QLocale(QLocale::English, QLocale::UnitedStates));

    StoragePlaces *storagePlaces = new StoragePlaces(&app);
    qmlRegisterSingletonInstance("com.kometa.StoragePlaces", 1, 1, "StoragePlaces", storagePlaces);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("ColdStorage", "Main");

    return app.exec();
}
