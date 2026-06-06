#include "MediaService.h"
#include <QUrl>
#include <QDebug>

MediaService::MediaService(QObject *parent)
    : QObject(parent)
{
    m_mediaPlayer = new QMediaPlayer(this);
    m_audioOutput = new QAudioOutput(this);

    m_mediaPlayer->setAudioOutput(m_audioOutput);

    connect(m_mediaPlayer, &QMediaPlayer::playbackStateChanged,
            this, &MediaService::playingChanged);

    connect(m_mediaPlayer, &QMediaPlayer::positionChanged,
            this, &MediaService::positionChanged);

    connect(m_mediaPlayer, &QMediaPlayer::durationChanged,
            this, &MediaService::durationChanged);

    connect(m_audioOutput, &QAudioOutput::volumeChanged,
            this, &MediaService::volumeChanged);

    connect(m_audioOutput, &QAudioOutput::mutedChanged,
            this, &MediaService::mutedChanged);

    // 🔥 FIX: proper metadata propagation
    connect(m_mediaPlayer, &QMediaPlayer::metaDataChanged,
            this, [this]() {
                emit titleChanged();
                emit artistChanged();
                emit genreChanged();
            });

    m_stations = {
        {
            "Quran Cairo",
            "https://stream.radiojar.com/8s5u5tpdtwzuv",
            "Recitation",
            "Quran",
            "qrc:/images/radio-cairo.png"
        },
        {
            "Al Husnaa Quran",
            "https://stream.zeno.fm/pyc8kax6f2zuv",
            "Recitation",
            "Quran",
            "qrc:/images/radio-madinah.jpeg"
        }
    };

    m_radioIndex = 0;
}

// ================= GETTERS =================

bool MediaService::playing() const {
    return m_mediaPlayer->playbackState() == QMediaPlayer::PlayingState;
}

qint64 MediaService::position() const {
    return m_mediaPlayer->position();
}

qint64 MediaService::duration() const {
    return m_mediaPlayer->duration();
}

bool MediaService::muted() const {
    return m_audioOutput->isMuted();
}

qreal MediaService::volume() const {
    return m_audioOutput->volume();
}

QString MediaService::title() const {
    return m_mediaPlayer->metaData().stringValue(QMediaMetaData::Title);
}

QString MediaService::artist() const {
    return m_mediaPlayer->metaData().stringValue(QMediaMetaData::ContributingArtist);
}

QString MediaService::genre() const {
    return m_mediaPlayer->metaData().stringValue(QMediaMetaData::Genre);
}

QString MediaService::stationName() const {
    return m_stations[m_radioIndex].name;
}

QString MediaService::stationImage() const {
    return m_stations[m_radioIndex].image;
}

QString MediaService::stationArtist() const
{
    return m_stations[m_radioIndex].artist;
}

// ================= SETTERS =================

void MediaService::setPosition(qint64 pos) {
    m_mediaPlayer->setPosition(pos);
}

void MediaService::setMuted(bool mute) {
    m_audioOutput->setMuted(mute);
}

void MediaService::setVolume(qreal vol) {
    m_audioOutput->setVolume(vol);
}

// ================= API =================

void MediaService::setAudioSource(const QString &file) {
    m_mediaPlayer->setSource(QUrl::fromLocalFile(file));
}

void MediaService::togglePlayPause() {
    if (m_mediaPlayer->playbackState() == QMediaPlayer::PlayingState)
        m_mediaPlayer->pause();
    else
        m_mediaPlayer->play();
}

void MediaService::stop() {
    m_mediaPlayer->stop();
}


void MediaService::playPrevStation()
{
    m_radioIndex = (m_radioIndex - 1 + m_stations.size()) % m_stations.size();
    setRadioSource(m_radioIndex);
}

void MediaService::playNextStation()
{
    m_radioIndex = (m_radioIndex + 1) % m_stations.size();
    setRadioSource(m_radioIndex);
}

void MediaService::setRadioSource(int index)
{
    if (index < 0 || index >= m_stations.size())
        return;

    m_radioIndex = index;

    bool wasPlaying =
        m_mediaPlayer->playbackState() == QMediaPlayer::PlayingState;

    m_mediaPlayer->setSource(QUrl(m_stations[m_radioIndex].url));

    if (wasPlaying)
        m_mediaPlayer->play();

    emit stationChanged();
}


