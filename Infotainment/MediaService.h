#ifndef MEDIASERVICE_H
#define MEDIASERVICE_H

#include <QObject>
#include <QVector>
#include <QMediaPlayer>
#include <QAudioOutput>
#include <QMediaMetaData>

struct Station {
    QString name;
    QString url;
    QString artist;
    QString genre;
    QString image;
};

class MediaService : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool playing READ playing NOTIFY playingChanged FINAL)
    Q_PROPERTY(qint64 position READ position WRITE setPosition NOTIFY positionChanged FINAL)
    Q_PROPERTY(qint64 duration READ duration NOTIFY durationChanged FINAL)
    Q_PROPERTY(bool muted READ muted WRITE setMuted NOTIFY mutedChanged FINAL)
    Q_PROPERTY(qreal volume READ volume WRITE setVolume NOTIFY volumeChanged FINAL)

    Q_PROPERTY(QString title READ title NOTIFY titleChanged FINAL)
    Q_PROPERTY(QString artist READ artist NOTIFY artistChanged FINAL)
    Q_PROPERTY(QString genre READ genre NOTIFY genreChanged FINAL)

    Q_PROPERTY(QString stationName READ stationName NOTIFY stationChanged FINAL)
    Q_PROPERTY(QString stationImage READ stationImage NOTIFY stationChanged FINAL)
    Q_PROPERTY(QString stationArtist READ stationArtist NOTIFY stationChanged FINAL)

public:
    explicit MediaService(QObject *parent = nullptr);

    bool playing() const;
    qint64 position() const;
    qint64 duration() const;
    bool muted() const;
    qreal volume() const;

    QString title() const;
    QString artist() const;
    QString genre() const;

    void setPosition(qint64 pos);
    void setMuted(bool mute);
    void setVolume(qreal vol);

    Q_INVOKABLE void setAudioSource(const QString &file);
    Q_INVOKABLE void togglePlayPause();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void playPrevStation();
    Q_INVOKABLE void playNextStation();
    Q_INVOKABLE void setRadioSource(int index);
    QString stationName() const;
    QString stationImage() const;
    QString stationArtist() const;

signals:
    void playingChanged();
    void positionChanged();
    void durationChanged();
    void mutedChanged();
    void volumeChanged();

    void titleChanged();
    void artistChanged();
    void genreChanged();

    void stationChanged();   // 🔥 ADD THIS

private:
    QMediaPlayer *m_mediaPlayer;
    QAudioOutput *m_audioOutput;

    QVector<Station> m_stations;
    int m_radioIndex;
};

#endif
