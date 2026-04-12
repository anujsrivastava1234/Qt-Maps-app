# 🗺️ Companion Map App

A modern, high-performance **map companion application** built using **Qt (QML + C++)** and **ArcGIS Runtime SDK**.
This app focuses on smooth UI, offline capabilities, and flexible map visualization.

---

## 🚀 Features

* 📍 **Offline Maps**

  * Download map areas and use them without internet

* 🌙 **Dark / Light Mode**

  * Seamless switching between day and night themes

* 🗺️ **Multiple Map Types**

  * Standard
  * Satellite
  * Terrain

* 📡 **Live Tracking**

  * Real-time location tracking with path rendering

* 🎨 **Modern UI**

  * Fluid animations
  * Clean layout
  * Interactive drawer navigation

---

## 📸 Screenshots

> [![Mapify Demo](https://github.com/user-attachments/assets/2e6227fd-e5f0-4e23-bff8-bcd40c2521a7)](https://youtu.be/UDFdp8JLu-M)


### 🏠 Main Map View

![Main Map](screenshots/main_map.png)

### 📂 Drawer Menu

![Drawer](screenshots/drawer.png)

### 🌙 Dark Mode

![Dark Mode](screenshots/dark_mode.png)

### 📴 Offline Map

![Offline Map](screenshots/offline.png)

---

## 🛠️ Tech Stack

* **Qt 6 (QML + C++)**
* **ArcGIS Runtime SDK**
* **Qt Quick Controls**
* **C++ Backend Integration**

---

## 📦 Installation

```bash
git clone https://github.com/your-username/companion-map-app.git
cd companion-map-app
```

### Requirements

* Qt 6.x
* ArcGIS Runtime SDK for Qt
* CMake / Qt Creator

---

## ▶️ Run the App

1. Open the project in **Qt Creator**
2. Configure Kit (Desktop / Android)
3. Build & Run

---

## 📂 Project Structure

```
├── qml/                # UI (QML)
├── Components/        # Reusable UI components
├── CompanionApp.cpp   # Backend logic
├── CompanionApp.h
├── Resources/         # Icons & assets
```

---

## 🧠 Key Concepts

* QML ↔ C++ integration via `Q_PROPERTY`
* Real-time location tracking using ArcGIS `LocationDisplay`
* Offline map generation using `ExportVectorTilesTask`
* Dynamic basemap switching

---

## ✨ Future Improvements

* 🔐 User authentication
* 📍 Saved locations sync
* 🧭 Route navigation
* ☁️ Cloud backup for offline maps

---

## 🤝 Contributing

Contributions, issues, and suggestions are welcome!

---

## 📄 License

This project is based on ESRI sample code and follows their usage guidelines.

---

## ⭐ Support

If you like this project, consider giving it a ⭐ on GitHub!
