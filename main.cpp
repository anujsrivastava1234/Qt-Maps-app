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

#include "ArcGISRuntimeEnvironment.h"
#include "MapQuickView.h"

#include <QDir>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

//------------------------------------------------------------------------------

using namespace Esri::ArcGISRuntime;

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    ArcGISRuntimeEnvironment::setUseLegacyAuthentication(false);
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

    const QString accessToken = QString("AAPTaaSDrINdzmiP_dhbt8D0fTA..TNL1XpV9Jz1IWzuBkJ3FKz9Q2XDQr4dIYyTi_SeTOEpwqAN58GDAx5nR-Gj7fqndYhPvKqm4UJ2STgCHgm7sdUJ6vqDXMIXhIIkkvyrx0V-PLvkZC1DW4g2Be_KEmUiCwgkGI5jzv7O8hPIC-si2Z2WNcnIuylCNYQ3kvLuGTKu7mnie2h3ucExfl3anoLGw1HNyh4KbfSRLZn6FsPsh5c01fQaddUQzFNcKN_b0vBaOTKdkHdmJVmw.AT1_90YVH5Mi");

    if (accessToken.isEmpty()) {
        qWarning()
            << "Use of ArcGIS location services, such as the basemap styles service, requires"
            << "you to authenticate with an ArcGIS account or set the API Key property.";
    } else {
        ArcGISRuntimeEnvironment::setApiKey(accessToken);
    }

    // Production deployment of applications built with ArcGIS Maps SDK requires you to
    // license ArcGIS Maps SDK functionality. For more information see
    // https://links.esri.com/arcgis-runtime-license-and-deploy.

    // ArcGISRuntimeEnvironment::setLicense("Place license string in here");

    // Register the map view for QML
    qmlRegisterType<MapQuickView>("Esri.CompanionApp", 1, 0, "MapView");

    // Register the CompanionApp (QQuickItem) for QML
    qmlRegisterType<CompanionApp>("Esri.CompanionApp", 1, 0, "CompanionApp");

    // Initialize application view
    QQmlApplicationEngine engine;

    // Add the import Path
    engine.addImportPath(QDir(QCoreApplication::applicationDirPath()).filePath("qml"));

    // Set the source
    engine.load(QUrl("qrc:/qml/main.qml"));

    return app.exec();
}

//------------------------------------------------------------------------------
