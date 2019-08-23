#include "system.hpp"
#include <QDebug>
#include <QNetworkInterface>
#include <QFile>
#include <QIODevice>
#include <QStandardPaths>

using namespace quarre;

Platform*
Platform::singleton;

#ifdef Q_OS_ANDROID
//-------------------------------------------------------------------------------------------------
Platform::Platform()
//-------------------------------------------------------------------------------------------------
{    

    auto activity   = QAndroidJniObject::callStaticObjectMethod(
                        "org/qtproject/qt5/android/QtNative",
                        "activity", "()Landroid/app/Activity;");

    auto ctx        = activity.callObjectMethod(
                        "getApplicationContext", "()Landroid/content/Context;");

    auto vibstr     = QAndroidJniObject::fromString("vibrator");
    m_vibrator      = ctx.callObjectMethod(
                        "getSystemService", "(Ljava/lang/String;)Ljava/lang/Object;",
                        vibstr.object<jstring>());

    auto powsvc     = QAndroidJniObject::getStaticObjectField<jstring>(
                        "android/content/Context", "POWER_SERVICE");

    auto power_mgr  = activity.callObjectMethod("getSystemService",
                        "(Ljava/lang/String;)Ljava/lang/Object;", powsvc.object<jstring>());

    auto lnf        = QAndroidJniObject::getStaticField<jint>(
                        "android/os/PowerManager", "SCREEN_BRIGHT_WAKE_LOCK");

    auto tag        = QAndroidJniObject::fromString("My Tag");
    m_wakelock      = power_mgr.callObjectMethod("newWakeLock",
                        "(ILjava/lang/String;)Landroid/os/PowerManager$WakeLock;",
                         lnf, tag.object<jstring>());

    if  (m_wakelock.isValid())
         m_wakelock.callMethod<void>("acquire", "()V");
    else qDebug() << "Unable to lock device..!!";

    singleton = this;

}

//---------------------------------------------------------------------------------------------
void
Platform::vibrate(int milliseconds) const
//---------------------------------------------------------------------------------------------
{    
    auto has_vibrator = m_vibrator.callMethod<jboolean>("hasVibrator", "()Z");
    jlong ms = milliseconds;

    m_vibrator.callMethod<void>("vibrate", "(J)V", ms);
}
#endif

//---------------------------------------------------------------------------------------------
QString
Platform::downloadPath() const
//---------------------------------------------------------------------------------------------
{
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
}
