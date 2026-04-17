#ifndef PORTALUSERINFO_H
#define PORTALUSERINFO_H

#include <QObject>

namespace Esri::ArcGISRuntime {
class Portal;
class PortalUser;
enum class LoadStatus;
}

class PortalUserInfo : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString fullName READ fullName NOTIFY fullNameChanged FINAL)
    Q_PROPERTY(QString email READ email NOTIFY emailChanged FINAL)
    Q_PROPERTY(QString loadErrorMessage READ loadErrorMessage NOTIFY loadErrorMessageChanged)
    Q_PROPERTY(bool loginDismissed READ loginDismissed NOTIFY loginDismissedChanged)

public:
    explicit PortalUserInfo(QObject *parent = nullptr);

    QString fullName() const;
    QString email() const;
    QString loadErrorMessage() const;
    bool loginDismissed() const;

signals:
    void fullNameChanged();
    void emailChanged();
    void loadedChanged();
    void loadErrorMessageChanged();
    void loginDismissedChanged();

private slots:
    void onPortalLoadStatusChanged(Esri::ArcGISRuntime::LoadStatus loadStatus);

private:
    static const QString UNKNOWN;

    Esri::ArcGISRuntime::Portal *m_portal = nullptr;
    Esri::ArcGISRuntime::PortalUser *m_user = nullptr;

    QString m_loadErrorMessage;
};

#endif // PORTALUSERINFO_H