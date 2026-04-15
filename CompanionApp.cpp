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
#include "AttributeListModel.h"
#include <EnvelopeBuilder.h>
#include <GenerateOfflineMapParameters.h>
#include <GenerateOfflineMapJob.h>
#include <GenerateOfflineMapResult.h>
#include <OfflineMapTask.h>
#include "GeocodeResult.h"
#include "LocatorTask.h"
#include "SimpleRenderer.h"
#include "SuggestParameters.h"
#include "SuggestListModel.h"
#include "SimpleMarkerSymbol.h"
#include "TextSymbol.h"

#include <QAbstractListModel>
#include <QGeoPositionInfoSource>
#include <QUrl>
#include <QUuid>
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

void CompanionApp::geocode(const QString &query)
{
    m_locatorTask->geocodeWithParametersAsync(query, m_geocodeParams).then(this, [this](const QList<GeocodeResult>& geocodeResults){
        if(!geocodeResults.isEmpty() && m_graphicResultLocation)
            {
            const GeocodeResult geocodeResult = geocodeResults.at(0);
            m_graphicResultLocation->setGeometry(geocodeResult.displayLocation());
            m_graphicResultLocation->attributes()->setAttributesMap(geocodeResult.attributes());
            constexpr double scale = 8000.0;

            m_mapView->setViewpointCenterAsync(geocodeResult.extent().center(), scale);

            m_graphicResultLocation->setVisible(true);
            m_textSymbol->setText(geocodeResult.label());
            m_graphicResultText->setGeometry(geocodeResult.displayLocation());
            m_graphicResultText->attributes()->setAttributesMap(geocodeResult.attributes());
            m_graphicResultLocation->setVisible(true);
        }
    });
}

void CompanionApp::clearGraphics()
{
    m_graphicResultLocation->setGeometry(Point());
    m_graphicResultText->setGeometry(Point());
}

CompanionApp::CompanionApp(QObject *parent /* = nullptr */)
    : QObject(parent)
    , m_map(new Map(BasemapStyle::ArcGISNavigation, this))
{

    setupLocatarTask();
}

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
    connect(m_mapView, &MapQuickView::mouseClicked, this, [this](QMouseEvent& pressed){
        emit hideSuggestionView();
    });
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

    //configure marker graphics
    configureGraphics();
}

//Task Locator
void CompanionApp::setupLocatarTask()
{
    //Add the server link
    const QUrl geocode_service("https://geocode-api.arcgis.com/arcgis/rest/services/World/GeocodeServer");
    m_locatorTask = new LocatorTask(geocode_service, this);

    SuggestParameters _suggestParameters;
    const QStringList categories{"Address", "POI", "Populated Place"};
    _suggestParameters.setCategories(categories);
    _suggestParameters.setMaxResults(5);
    m_locatorTask->suggestions()->setSuggestParameters(_suggestParameters);

    m_geocodeParams.setMinScore(5);
    m_geocodeParams.setResultAttributeNames(QStringList {"Place_addr", "Match_addr"});
    m_suggestions = m_locatorTask->suggestions();
    emit suggestionsChanged();

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

void CompanionApp::configureGraphics()
{
    if(m_graphicResultLocation)
        return;
    //Create a graphics overlay and add to the map
    m_graphicsOverlay = new GraphicsOverlay(this);

    //set a renderer in graphics overlay
    SimpleRenderer *m_renderer = new SimpleRenderer(this);

    //Create a symbol marker
    SimpleMarkerSymbol *simpleMarkerSymbol = new SimpleMarkerSymbol(SimpleMarkerSymbolStyle::Circle, QColor("#01ffe6"), 15.0, this);
    m_renderer->setSymbol(simpleMarkerSymbol);
    m_graphicResultLocation = new Graphic(this);
    m_graphicResultLocation->setSymbol(simpleMarkerSymbol);
    m_graphicsOverlay->graphics()->append(m_graphicResultLocation);

    // Create a graphic and symbol to display a label next to the result location
    m_textSymbol = new TextSymbol("", QColor("Red"), 14.0, HorizontalAlignment::Center, VerticalAlignment::Bottom, this);
    m_graphicResultText = new Graphic(this);
    m_graphicResultText->setSymbol(m_textSymbol);

    m_graphicsOverlay->graphics()->append(m_graphicResultText);

    m_mapView->graphicsOverlays()->append(m_graphicsOverlay);
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
QAbstractListModel *CompanionApp::suggestions() const
{
    return m_suggestions;
}

void CompanionApp::setSuggestions(const QString &text)
{
    if(!m_suggestions)
        return;

    SuggestListModel *_suggestListModel = dynamic_cast<SuggestListModel*>(m_suggestions);

    if(!m_suggestions)
        return;

    _suggestListModel->setSearchText(text);
}
