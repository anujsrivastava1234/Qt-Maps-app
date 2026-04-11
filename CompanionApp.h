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
class Graphic;
class PolylineBuilder;
class ArcGISVectorTiledLayer;
class ExportVectorTilesTask;
class ExportVectorTilesJob;
class PortalItem;
class OfflineMapTask;
} // namespace Esri::ArcGISRuntime

#include <QObject>

Q_MOC_INCLUDE("MapQuickView.h")

enum MapTypes{
    OpenStreets,
    OpenStreetsNight
};

class CompanionApp : public QObject
{
    Q_OBJECT

    Q_PROPERTY(Esri::ArcGISRuntime::MapQuickView *mapView READ mapView WRITE setMapView NOTIFY
                   mapViewChanged)
    Q_PROPERTY(bool isTracking READ isTracking WRITE setIsTracking NOTIFY isTrackingChanged FINAL)
    Q_PROPERTY(int downloadProgress READ downloadProgress WRITE setDownloadProgress NOTIFY downloadProgressChanged FINAL)
    Q_PROPERTY(bool nightModeEnabled READ nightModeEnabled WRITE setNightModeEnabled NOTIFY nightModeEnabledChanged FINAL)
    Q_PROPERTY(bool offlineModeEnabled READ offlineModeEnabled WRITE setOfflineModeEnabled NOTIFY offlineModeEnabledChanged FINAL)

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

    bool offlineModeEnabled() const;
    void setOfflineModeEnabled(bool newOfflineModeEnabled);

signals:
    void mapViewChanged();
    void isTrackingChanged();
    void nightModeEnabledChanged();

    void downloadProgressChanged();

    void offlineModeEnabledChanged();

private:
    Esri::ArcGISRuntime::MapQuickView *mapView() const;
    void setMapView(Esri::ArcGISRuntime::MapQuickView *mapView);
    Esri::ArcGISRuntime::Map *m_map = nullptr;
    Esri::ArcGISRuntime::MapQuickView *m_mapView = nullptr;
    Esri::ArcGISRuntime::ExportVectorTilesTask *m_exportTask = nullptr;
    bool m_isTracking;
    void exportVectorTile(Esri::ArcGISRuntime::ArcGISVectorTiledLayer *layer);
    enum MapTypes mapTypes = OpenStreets;
    bool m_nightModeEnabled = false;
    Esri::ArcGISRuntime::ExportVectorTilesJob *m_exportJob = nullptr;
    Esri::ArcGISRuntime::PortalItem *m_portalItem = nullptr;
    Esri::ArcGISRuntime::OfflineMapTask *m_offlinemapTask = nullptr;

    int m_downloadProgress{0};
    bool m_offlineModeEnabled = false;
};

#endif // COMPANIONAPP_H
