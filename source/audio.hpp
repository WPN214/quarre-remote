#ifndef AUDIO_HDL_HPP
#define AUDIO_HDL_HPP

#include <QObject>
#include <QAudioInput>
#include <QIODevice>
#include <QtDebug>

namespace quarre
{
class audio_hdl : public QIODevice
{
    Q_OBJECT
    Q_PROPERTY  ( qreal rms READ rms )
    Q_PROPERTY  ( bool available READ available )
    Q_PROPERTY  ( bool active READ active WRITE setActive )

    public:
    audio_hdl ( );

    virtual qint64 readData         ( char *data, qint64 maxlen ) override;
    virtual qint64 writeData        ( const char* data, qint64 len ) override;
    virtual qint64 bytesAvailable   ( ) const override;

    qreal rms ( ) const { return m_rms; }
    bool available ( ) const { return true; } // hmm...

    bool active     ( ) const { return m_active; }
    Q_INVOKABLE void setActive ( bool active );

    signals:
    void activeChanged();

    public slots:
    void monitor_input_state ( QAudio::State state ) { qDebug() << state; }

    private:
    QAudioInput* m_input;
    qreal m_rms;
    bool m_active;
};
}

#endif // AUDIO_HDL_HPP
