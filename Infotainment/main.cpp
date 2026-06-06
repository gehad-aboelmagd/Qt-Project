#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "PageNavigator.h"
#include "MediaService.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);    
    QQmlApplicationEngine engine;

    PageNavigator* navigator = new PageNavigator(&app);
    engine.rootContext()->setContextProperty("myNavigator", navigator);

    MediaService *mediaService = new MediaService();

    engine.rootContext()->setContextProperty("MediaService", mediaService);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Infotainment", "Main");

    return app.exec();
}
