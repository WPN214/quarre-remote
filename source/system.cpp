#include "system.hpp"
#include <QDebug>
#include <QNetworkInterface>
#include <QFile>
#include <QIODevice>
#include <QStandardPaths>

using namespace quarre;

platform_hdl* platform_hdl::singleton;
platform_hdl::platform_hdl()
{    

#ifdef Q_OS_ANDROID

    auto activity   = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");
    auto ctx        = activity.callObjectMethod("getApplicationContext", "()Landroid/content/Context;");

    // -----------  VIBRATOR
    auto vibstr     = QAndroidJniObject::fromString("vibrator");
    m_vibrator      = ctx.callObjectMethod("getSystemService", "(Ljava/lang/String;)Ljava/lang/Object;", vibstr.object<jstring>());

    // ----------   WAKELOCK
    auto powsvc     = QAndroidJniObject::getStaticObjectField<jstring>("android/content/Context", "POWER_SERVICE");
    auto power_mgr  = activity.callObjectMethod("getSystemService", "(Ljava/lang/String;)Ljava/lang/Object;", powsvc.object<jstring>());
    auto lnf        = QAndroidJniObject::getStaticField<jint>("android/os/PowerManager", "SCREEN_BRIGHT_WAKE_LOCK");
    auto tag        = QAndroidJniObject::fromString("My Tag");
    m_wakelock      = power_mgr.callObjectMethod("newWakeLock", "(ILjava/lang/String;)Landroid/os/PowerManager$WakeLock;", lnf, tag.object<jstring>());

    if      ( m_wakelock.isValid() )
            m_wakelock.callMethod<void>("acquire", "()V");
    else    qDebug() << "Unable to lock device..!!";

#endif

    singleton = this;

}

platform_hdl::~platform_hdl() {}


#include <QMetaObject>

void platform_hdl::vibrate(int milliseconds) const
{    
    #ifdef Q_OS_ANDROID // ---------------------------------------------------------------------------------------
    jboolean has_vibrator   = m_vibrator.callMethod<jboolean>("hasVibrator", "()Z");
    jlong ms                = milliseconds;

    m_vibrator.callMethod<void>("vibrate", "(J)V", ms);
    #endif
}

QString platform_hdl::downloadPath() const
{
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
}
