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

#include "Map.h"
#include "MapQuickView.h"
#include "MapTypes.h"
#include "LocationDisplay.h"
#include "MapViewTypes.h"
#include <Graphic.h>
#include <GraphicsOverlay.h>
#include <GraphicsOverlayListModel.h>
#include <SimpleLineSymbol.h>
#include <SymbolTypes.h>
#include <GraphicListModel.h>
#include <PolylineBuilder.h>
#include <SpatialReference.h>
#include <Location.h>
#include <Point.h>
#include <Basemap.h>
#include "LayerListModel.h"
#include "ArcGISVectorTiledLayer.h"
#include <ExportVectorTilesTask.h>
#include <ExportVectorTilesParameters.h>
#include <GeometryEngine.h>
#include <Polygon.h>
#include <QFuture>
#include <QStandardPaths>
#include <QString>
#include <QDir>
#include "Error.h"
#include <QObject>
#include <Job.h>
#include <ExportVectorTilesJob.h>
#include <Portal.h>
#include <Envelope.h>
#include <EnvelopeBuilder.h>
#include <GenerateOfflineMapParameters.h>
#include <GenerateOfflineMapJob.h>
#include <GenerateOfflineMapResult.h>
#include <OfflineMapTask.h>
QString vtpkFileName = "";

using namespace Esri::ArcGISRuntime;
const QString appDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/CompanionApp";

void CompanionApp::createOfflineAreaFromExtend()
{
    for(Layer* layers : *(m_map->basemap()->baseLayers()))
    {
        if(ArcGISVectorTiledLayer *vectorTileLayer = dynamic_cast<ArcGISVectorTiledLayer*>(layers))
        {
            exportVectorTile(vectorTileLayer);
            break;
        }
    }
}

CompanionApp::CompanionApp(QObject *parent /* = nullptr */)
    : QObject(parent)
    , m_map(new Map(BasemapStyle::ArcGISNavigation, this))
{}

CompanionApp::~CompanionApp() = default;

bool CompanionApp::isTracking() const
{
    return m_isTracking;
}

void CompanionApp::setIsTracking(bool newIsTracking)
{
    if (m_isTracking == newIsTracking)
        return;
    m_isTracking = newIsTracking;
    emit isTrackingChanged();
}

void CompanionApp::setupTracking()
{
    qInfo() << "Setup Tracking" << this->objectName();
    GraphicsOverlay *_graphicsOverlay = new GraphicsOverlay(this);
    m_mapView->graphicsOverlays()->append(_graphicsOverlay);

    m_pathGraphics = new Graphic(this);
    m_pathGraphics->setSymbol(new SimpleLineSymbol(SimpleLineSymbolStyle::Solid, Qt::blue, 5, this));
    _graphicsOverlay->graphics()->append(m_pathGraphics);

    m_polyLine = new PolylineBuilder(m_mapView->spatialReference(), this);

    connect(m_mapView->locationDisplay(), &LocationDisplay::locationChanged, this, [=](const Location &l)
    {
        if(!m_isTracking)
            return;

        m_polyLine->addPoint(l.position());
        m_pathGraphics->setGeometry(m_polyLine->toGeometry());

        m_mapView->locationDisplay()->setAutoPanMode(LocationDisplayAutoPanMode::CompassNavigation);

    });
}

MapQuickView *CompanionApp::mapView() const
{
    return m_mapView;
}

// Set the view (created in QML)
void CompanionApp::setMapView(MapQuickView *mapView)
{
    if (!mapView || mapView == m_mapView) {
        return;
    }

    m_mapView = mapView;
    m_mapView->setMap(m_map);
    m_mapView->locationDisplay()->start();
    m_mapView->locationDisplay()->setAutoPanMode(LocationDisplayAutoPanMode::Recenter);
    m_mapView->setRotationByPinchingEnabled(true);
    emit mapViewChanged();

    setupTracking();
}

void CompanionApp::exportVectorTile(Esri::ArcGISRuntime::ArcGISVectorTiledLayer *layer)
{
    m_exportTask = new ExportVectorTilesTask(layer->url(), this);
    m_exportTask->createDefaultExportVectorTilesParametersAsync(GeometryEngine::normalizeCentralMeridian(m_mapView->visibleArea()),
                                                                 m_mapView->mapScale() * 0.1).then(this,
                                                                [this](const ExportVectorTilesParameters& defaultParams)
    {
        if(QDir().exists(appDataPath))
        {
                      QDir path(appDataPath);
            path.removeRecursively();

        }
        QDir().mkpath(appDataPath);

        vtpkFileName = appDataPath+"/vectorTiles.vtpk";
        qDebug() << "Download path:" << vtpkFileName;
        const QString itemResourceString = appDataPath + "/itemResources";

        m_exportJob = m_exportTask->exportVectorTiles(defaultParams, vtpkFileName, itemResourceString);

        QObject::connect(m_exportJob, &Job::progressChanged, this, [this](){
            m_downloadProgress = m_exportJob->progress();
            qDebug() << m_downloadProgress;
            emit downloadProgressChanged();
        }, Qt::AutoConnection);

        connect(m_exportJob, &Job::errorOccurred, this, [](const Error &e){
            qWarning() << e.message() << e.additionalMessage();
        });

        m_exportJob->start();
    });
}

bool CompanionApp::nightModeEnabled() const
{
    return m_nightModeEnabled;
}

void CompanionApp::setNightModeEnabled(bool newNightModeEnabled)
{
    if (m_nightModeEnabled == newNightModeEnabled)
        return;
    m_nightModeEnabled = newNightModeEnabled;
    updateBaseMap();
    emit nightModeEnabledChanged();
}

int CompanionApp::downloadProgress() const
{
    return m_downloadProgress;
}

void CompanionApp::setDownloadProgress(int newDownloadProgress)
{
    if (m_downloadProgress == newDownloadProgress)
        return;
    m_downloadProgress = newDownloadProgress;
    emit downloadProgressChanged();
}

bool CompanionApp::offlineModeEnabled() const
{
    return m_offlineModeEnabled;
}

void CompanionApp::setOfflineModeEnabled(bool newOfflineModeEnabled)
{
    if (m_offlineModeEnabled == newOfflineModeEnabled)
        return;
    m_offlineModeEnabled = newOfflineModeEnabled;
    updateBaseMap();
    emit offlineModeEnabledChanged();
}

int CompanionApp::mapType() const
{
    return m_mapType;
}

void CompanionApp::setMapType(int newMapType)
{
    if (m_mapType == newMapType)
        return;

    m_mapType = newMapType;
    updateBaseMap();
    emit mapTypeChanged();
}

void CompanionApp::updateBaseMap()
{
    // If we are in offline mode, we stay on the local VTPK
    if (m_offlineModeEnabled)
    {
        if (QFile::exists(vtpkFileName)) {
            auto vtlkLayer = new ArcGISVectorTiledLayer(vtpkFileName, this);
            m_map->setBasemap(new Basemap(vtlkLayer, this));
        }
        return;
    }

    BasemapStyle style;
    if (m_nightModeEnabled)
    {
        switch (m_mapType)
        {
        case 0:  style = BasemapStyle::ArcGISNavigationNight; break;
        case 1:  style = BasemapStyle::ArcGISImageryStandard; break; // Imagery usually doesn't have a night mode
        case 2:  style = BasemapStyle::ArcGISTerrainDetail;    break;
        default: style = BasemapStyle::ArcGISNavigationNight; break;
        }
    }
    else
    {
        switch (m_mapType)
        {
        case 0:  style = BasemapStyle::ArcGISNavigation; break;
        case 1:  style = BasemapStyle::ArcGISImageryStandard; break;
        case 2:  style = BasemapStyle::ArcGISTerrain; break;
        default: style = BasemapStyle::ArcGISNavigation; break;
        }
    }

    m_map->setBasemap(new Basemap(style, this));
}