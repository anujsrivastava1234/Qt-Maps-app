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

#ifndef COMPANIONAPP_H
#define COMPANIONAPP_H

namespace Esri::ArcGISRuntime {
class Map;
class MapQuickView;
class GraphicsOverlay;
class Graphic;
class LocatorTask;
class GeocodeResult;
class SuggestResult;
class TextSymbol;
class PolylineBuilder;
class ArcGISVectorTiledLayer;
class ExportVectorTilesTask;
class ExportVectorTilesJob;
class PortalItem;
class OfflineMapTask;
class RouteParameters;
class RouteTask;
class RouteTracker;
class SimulatedLocationDataSource;
} // namespace Esri::ArcGISRuntime

#include <QObject>

Q_MOC_INCLUDE("MapQuickView.h")

#include <QAbstractListModel>
#include "GeocodeParameters.h"
#include "Route.h"
#include "DirectionManeuver.h"
#include "RouteParameters.h"
#include "RouteResult.h"

class QTextToSpeech;



enum MapTypes{
    STANDARD = 0,
    SATELLITE,
    TERRAIN
};

class CompanionApp : public QObject
{
    Q_OBJECT
    Q_ENUM(MapTypes)

    Q_PROPERTY(Esri::ArcGISRuntime::MapQuickView *mapView READ mapView WRITE setMapView NOTIFY
                   mapViewChanged)
    Q_PROPERTY(bool isTracking READ isTracking WRITE setIsTracking NOTIFY isTrackingChanged FINAL)
    Q_PROPERTY(int downloadProgress READ downloadProgress WRITE setDownloadProgress NOTIFY downloadProgressChanged FINAL)
    Q_PROPERTY(bool nightModeEnabled READ nightModeEnabled WRITE setNightModeEnabled NOTIFY nightModeEnabledChanged FINAL)
    Q_PROPERTY(bool offlineModeEnabled READ offlineModeEnabled WRITE setOfflineModeEnabled NOTIFY offlineModeEnabledChanged FINAL)
    Q_PROPERTY(int mapType READ mapType WRITE setMapType NOTIFY mapTypeChanged)
    Q_PROPERTY(QAbstractListModel* suggestions READ suggestions  NOTIFY suggestionsChanged FINAL)

    //----------------------------------- Navigation API ---------------------------------------//
    Q_PROPERTY(bool navigationEnabled READ navigationEnabled WRITE setNavigationEnabled NOTIFY navigationEnabledChanged FINAL)
    Q_PROPERTY(bool recenterEnabled READ recenterEnabled WRITE setRecenterEnabled NOTIFY recenterEnabledChanged FINAL)
    Q_PROPERTY(QString textString READ textString WRITE setTextString NOTIFY textStringChanged FINAL)

public:
    explicit CompanionApp(QObject *parent = nullptr);
    ~CompanionApp() override;

    bool isTracking() const;
    void setIsTracking(bool newIsTracking);
    void setupTracking();


    Esri::ArcGISRuntime::Graphic *m_pathGraphics = nullptr;
    Esri::ArcGISRuntime::PolylineBuilder *m_polyLine = nullptr;
    bool nightModeEnabled() const;
    void setNightModeEnabled(bool newNightModeEnabled);

    int downloadProgress() const;
    void setDownloadProgress(int newDownloadProgress);

    Q_INVOKABLE void createOfflineAreaFromExtend();
    Q_INVOKABLE void geocode(const QString& query);
    Q_INVOKABLE void clearGraphics();
    Q_INVOKABLE void setSuggestions(const QString& text);

    Q_INVOKABLE void startNavigation();
    Q_INVOKABLE void recenterMap();

    bool offlineModeEnabled() const;
    void setOfflineModeEnabled(bool newOfflineModeEnabled);

    int mapType() const;
    void setMapType(int newMapType);

    void updateBaseMap();

    QAbstractListModel *suggestions() const;

    bool navigationEnabled() const;
    void setNavigationEnabled(bool newNavigationEnabled);

    bool recenterEnabled() const;
    void setRecenterEnabled(bool newRecenterEnabled);

    QString textString() const;
    void setTextString(const QString &newTextString);

    void initializeRoute();
    void connectRouteTrackerSignals();

signals:
    void mapViewChanged();
    void isTrackingChanged();
    void nightModeEnabledChanged();
    void downloadProgressChanged();
    void offlineModeEnabledChanged();
    void mapTypeChanged();
    void hideSuggestionView();
    void suggestionsChanged();
    void navigationEnabledChanged();
    void recenterEnabledChanged();
    void textStringChanged();

private:
    Esri::ArcGISRuntime::MapQuickView *mapView() const;
    void setMapView(Esri::ArcGISRuntime::MapQuickView *mapView);
    void setupLocatarTask();
    Esri::ArcGISRuntime::Map *m_map = nullptr;
    Esri::ArcGISRuntime::MapQuickView *m_mapView = nullptr;
    Esri::ArcGISRuntime::ExportVectorTilesTask *m_exportTask = nullptr;
    void exportVectorTile(Esri::ArcGISRuntime::ArcGISVectorTiledLayer *layer);
    Esri::ArcGISRuntime::ExportVectorTilesJob *m_exportJob = nullptr;
    Esri::ArcGISRuntime::PortalItem *m_portalItem = nullptr;
    Esri::ArcGISRuntime::OfflineMapTask *m_offlinemapTask = nullptr;

    //Search bar model
    void configureGraphics();
    Esri::ArcGISRuntime::GraphicsOverlay *m_graphicsOverlay = nullptr;
    Esri::ArcGISRuntime::LocatorTask *m_locatorTask = nullptr;
    Esri::ArcGISRuntime::Graphic* m_graphicResultLocation = nullptr;
    Esri::ArcGISRuntime::Graphic* m_graphicResultText = nullptr;
    Esri::ArcGISRuntime::TextSymbol* m_textSymbol = nullptr;
    QAbstractListModel *m_suggestions = nullptr;
    Esri::ArcGISRuntime::GeocodeParameters m_geocodeParams;

    //-----------Routing--------------//
    Esri::ArcGISRuntime::Graphic* m_routeAheadGrapghics = nullptr;
    Esri::ArcGISRuntime::Graphic* m_routeTravelledGraphics = nullptr;
    Esri::ArcGISRuntime::GraphicsOverlay* m_routeOverlay = nullptr;
    Esri::ArcGISRuntime::RouteTask *m_routeTask = nullptr;
    Esri::ArcGISRuntime::RouteResult m_routeResult;
    Esri::ArcGISRuntime::Route m_route;
    Esri::ArcGISRuntime::RouteTracker *m_routeTracker = nullptr;
    Esri::ArcGISRuntime::SimulatedLocationDataSource *m_simulatedLocationDataSource = nullptr;
    Esri::ArcGISRuntime::RouteParameters m_routeparamters;
    QList<Esri::ArcGISRuntime::DirectionManeuver>  m_directionManeuvers;
    QTextToSpeech *m_speaker = nullptr;


    bool m_isTracking = false;
    bool m_nightModeEnabled = false;
    int m_downloadProgress{0};
    bool m_offlineModeEnabled = false;
    int m_mapType = 0;
    bool m_navigationEnabled = false;
    bool m_recenterEnabled = true;
    QString m_textString = "";
};

#endif // COMPANIONAPP_H
