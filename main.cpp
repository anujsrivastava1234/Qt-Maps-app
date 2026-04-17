// Copyright 2026 ESRI
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this sample code, with or
// without modification, provided you include the original copyright
// notice and use restrictions.
//
// See the Sample code usage restrictions document for further information.
//

#include "CompanionApp.h"
#include "portaluserinfo.h"

#include "ArcGISRuntimeEnvironment.h"
#include "Esri/ArcGISRuntime/Toolkit/register.h"
#include "MapQuickView.h"
#include "OAuthUserConfigurationManager.h"

#include <Authentication/OAuthUserConfiguration.h>
#include <QDir>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QPermission>
#include <QtWebView>

//------------------------------------------------------------------------------

using namespace Esri::ArcGISRuntime;

int main(int argc, char *argv[])
{
    QtWebView::initialize();
    QGuiApplication app(argc, argv);
    ArcGISRuntimeEnvironment::setUseLegacyAuthentication(false);

    QLocationPermission locationPermission;
    locationPermission.setAccuracy(QLocationPermission::Precise);
    // Use of ArcGIS location services, such as basemap styles, geocoding, and routing services,
    // requires an access token. For more information see
    // https://links.esri.com/arcgis-runtime-security-auth.

    // The following methods grant an access token:

    // 1. User authentication: Grants a temporary access token associated with a user's ArcGIS account.
    // To generate a token, a user logs in to the app with an ArcGIS account that is part of an
    // organization in ArcGIS Online or ArcGIS Enterprise.

    // 2. API key authentication: Get a long-lived access token that gives your application access to
    // ArcGIS location services. Go to the tutorial at https://links.esri.com/create-an-api-key.
    // Copy the API Key access token.

    // OAuth user authentication: the user logs in with their ArcGIS account.
    // Register your app at https://developers.arcgis.com to get a client ID,
    // then add a redirect URI (e.g. "my-app://auth") in the app's OAuth settings.
    const QString clientId = QString("GA5XsmQs90YVH5Mi");
    const QString redirectUri = QString("urn:ietf:wg:oauth:2.0:oob");

    auto* oauthConfig = new Authentication::OAuthUserConfiguration(
        QUrl("https://www.arcgis.com/sharing/rest"),
        clientId,
        redirectUri,
        &app
    );
    Toolkit::OAuthUserConfigurationManager::addConfiguration(oauthConfig);

    // Production deployment of applications built with ArcGIS Maps SDK requires you to
    // license ArcGIS Maps SDK functionality. For more information see
    // https://links.esri.com/arcgis-runtime-license-and-deploy.

    // ArcGISRuntimeEnvironment::setLicense("Place license string in here");

    // Register the map view for QML
    qmlRegisterType<MapQuickView>("Esri.CompanionApp", 1, 0, "MapView");

    // Register the CompanionApp (QQuickItem) for QML
    qmlRegisterType<CompanionApp>("Esri.CompanionApp", 1, 0, "CompanionApp");

    //Register the Portal class
    qmlRegisterType<PortalUserInfo>("Esri.CompanionApp", 1, 0, "PortalUserInfo");

    // Initialize application view
    QQmlApplicationEngine engine;
     Esri::ArcGISRuntime::Toolkit::registerComponents(engine);

    // Add the import Path
    engine.addImportPath(QDir(QCoreApplication::applicationDirPath()).filePath("qml"));

    // Set the source
    engine.load(QUrl("qrc:/qml/main.qml"));

    return app.exec();
}

//------------------------------------------------------------------------------
