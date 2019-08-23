#ifndef OSBRIDGE_H
#define OSBRIDGE_H

#ifdef ANDROID
#include "jni.h"
#include <QtAndroid>
#include <QtAndroidExtras/QAndroidJniObject>
#include <QAndroidJniEnvironment>
#endif

namespace quarre {
//=================================================================================================
class Platform : public QObject
//=================================================================================================
{
    Q_OBJECT

    QString
    m_host;

    uint16_t
    m_port = 0;

#ifdef Q_OS_ANDROID
    QAndroidJniObject
    m_vibrator,
    m_wakelock;
#endif

public:

    Platform();

    //---------------------------------------------------------------------------------------------
    ~Platform() {}

    //---------------------------------------------------------------------------------------------
    static Platform*
    singleton;

    //---------------------------------------------------------------------------------------------
    Q_SLOT void
    vibrate(int milliseconds) const;

    //---------------------------------------------------------------------------------------------
    Q_SLOT QString
    downloadPath() const;

};

}

#endif // OSBRIDGE_H
