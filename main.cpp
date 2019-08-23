#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "source/system.hpp"
#include <QObject>
#include <QQmlComponent>

//-------------------------------------------------------------------------------------------------
int
main(int argc, char *argv[])
//-------------------------------------------------------------------------------------------------
{
#if defined(Q_OS_WIN)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    qmlRegisterType<quarre::Platform>
    ("Quarre", 1, 0, "Platform");

    QQmlApplicationEngine engine;

    engine.load(QUrl(QStringLiteral("qrc:/Main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    QObject::connect(&engine, SIGNAL(quit()), &app, SLOT(quit()));
    return app.exec();
}
