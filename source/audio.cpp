#include "audio.hpp"
#include <qendian.h>
#include <math.h>

using namespace quarre;

audio_hdl::audio_hdl() : m_input(0)
{
    QAudioFormat format;
    format.setSampleRate    ( 44100 );
    format.setChannelCount  ( 1 );
    format.setSampleSize    ( 16 );
    format.setCodec         ( "audio/pcm" );
    format.setByteOrder     ( QAudioFormat::LittleEndian );
    format.setSampleType    ( QAudioFormat::SignedInt );

    m_input = new QAudioInput ( format, this );
    open ( QIODevice::WriteOnly );

    QObject::connect ( m_input, SIGNAL(stateChanged(QAudio::State)),
                       this, SLOT(monitor_input_state(QAudio::State)) );
}

qint64 audio_hdl::readData(char *data, qint64 maxlen)
{
    Q_UNUSED ( data );
    Q_UNUSED ( maxlen );

    return 0;
}

void audio_hdl::setActive ( bool active )
{
    if ( active && !m_active )
        m_input->start(this);

    else if ( !active && m_active )
        m_input->stop();

    if ( active != m_active )
        emit activeChanged();

    m_active = active;
}

qint64 audio_hdl::writeData(const char *data, qint64 len)
{
    qint64 res = 0;

    for ( qint64 i = 0; i < 256; ++i )
    {
        res     += pow(qFromLittleEndian<qint16>(data), 2);
        data    += 2;
    }

    m_rms = sqrt(1.f/256.f*res)/20000.f;
    return 256;
}

qint64 audio_hdl::bytesAvailable() const
{
    return 256;
}
