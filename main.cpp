#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <mapimage.h>

int main(int argc, char *argv[])
{
    qmlRegisterType<MapImage>("Pathfinder",0,1,"MapImage");
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
