#include "portaluserinfo.h"
#include "Portal.h"
#include "PortalInfo.h"
#include "PortalUser.h"
#include "Error.h"
// Qt headers
#include <Authentication/OAuthUserConfiguration.h>
#include <MapTypes.h>
#include <QUrl>

// Other headers

using namespace Esri::ArcGISRuntime;
using namespace Esri::ArcGISRuntime::Authentication;
const QString PortalUserInfo::UNKNOWN = "Unknown";

PortalUserInfo::PortalUserInfo(QObject *parent)
    : QObject{parent},
    m_portal(new Portal(true, this))
{
    m_portal->load();
    connect(m_portal, &Portal::loadStatusChanged, this, &PortalUserInfo::onPortalLoadStatusChanged);
    connect(m_portal, &Portal::doneLoading, this, &::PortalUserInfo::loadErrorMessage);
}

QString PortalUserInfo::fullName() const
{
    if (m_user)
        return m_user->fullName();

    return "John Doe";
}

QString PortalUserInfo::email() const
{
    if (m_user)
        return m_user->email();

    return "john@gmail.com";
}

void PortalUserInfo::onPortalLoadStatusChanged(Esri::ArcGISRuntime::LoadStatus loadStatus)
{
    switch (loadStatus) {
    case LoadStatus::Loaded:
         m_user = m_portal->portalUser();
        emit fullNameChanged();
        emit emailChanged();
        break;
    case LoadStatus::Loading:
        break;
    case LoadStatus::FailedToLoad:
        break;
    case LoadStatus::NotLoaded:
        break;
    case LoadStatus::Unknown:
        break;
    default:
        break;
    }
    emit loadedChanged();
    emit loginDismissed();
}

QString PortalUserInfo::loadErrorMessage() const
{
    return m_loadErrorMessage;
}

bool PortalUserInfo::loginDismissed() const
{
    if (m_portal)
        return m_portal->loadError().errorType() == ErrorType::AuthenticationChallengeCanceled;

    return false;
}
