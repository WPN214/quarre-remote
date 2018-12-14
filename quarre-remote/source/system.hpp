#ifndef OSBRIDGE_H
#define OSBRIDGE_H

#ifdef ANDROID
#include "jni.h"
#include <QtAndroid>
#include <QtAndroidExtras/QAndroidJniObject>
#include <QAndroidJniEnvironment>
#endif
#include <QTimer>

namespace quarre {

class platform_hdl : public QObject
{
    Q_OBJECT

    public:
    platform_hdl   ( );
    ~platform_hdl  ( );

    static platform_hdl* singleton;

    public slots:
    void vibrate ( int milliseconds )  const;
    QString downloadPath() const;

    private:
    QString m_hostAddr;
    quint16 m_port;

#ifdef Q_OS_ANDROID
    QAndroidJniObject  m_vibrator;
    QAndroidJniObject  m_wakelock;
#endif

};

}

#endif // OSBRIDGE_H
