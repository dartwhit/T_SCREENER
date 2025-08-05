# SCREENER

**S**Sc and o**C**td in or around a**Re**as with **Environm**Ent co**NcER**ns

![SCREENER screenshot](insert-screenshot-url-here)

> Interactive geospatial web app for visualizing incidence rates of Systemic Sclerosis (SSc) and other Connective Tissue Diseases (OCTD) in relation to Superfund sites across the United States.

## 🧠 Overview

Systemic Sclerosis (SSc) is a rare immune-mediated disease with suspected environmental triggers. Previous research showed spatial clusters of SSc cases near Superfund sites—areas designated for environmental cleanup due to hazardous waste.

**SCREENER** is a Shiny web application that:

- Visualizes SSc and OCTD incidence rates by ZIP code
- Overlays Superfund site locations
- Allows dynamic exploration of geospatial patterns
- Enables hypothesis generation for future epidemiological research

## 🚀 Features

- 🌍 Interactive map of the United States with disease incidence heatmaps
- 🧪 Overlay of Superfund site data from EPA/Columbia University
- 🔍 State-level zoom and incidence rate range customization
- ✅ Supports SSc or all OCTDs as input filters
- 📌 Geospatial shape files for ZIP code-level resolution

> Moran’s I clustering is not yet implemented but planned for future versions.

## 📦 Data Sources

- **SSc Incidence Data:** De-identified Medicare data (exported via DAC)
- **Superfund Site Locations:** Curated GPS coordinates dataset from Columbia University
- **ZIP Code Shape Data:** Extracted using `tigris` R package

## 🛠️ System Design

| Component              | Description                                                       |
|------------------------|-------------------------------------------------------------------|
| `data_preprocessing.R` | Prepares ZIP-level incidence and Superfund data for visualization |
| `ui.R`, `server.R`     | Shiny app files for rendering interactive map and controls        |
| `map_data.RData`       | Pre-processed and integrated dataset used by the Shiny app        |

## 📷 Screenshots

> Replace with actual screenshot once hosted

![Map with SSc incidence and Superfund overlay](insert-map-screenshot)

## 📈 Future Improvements

- Implement local Moran’s I clustering
- Add search-by-ZIP functionality
- Enable user-uploaded incidence datasets for broader usage
- Expand to support other diseases

## 🤝 Acknowledgments

This project was developed as part of the **QBS 192** course at Dartmouth College.

Special thanks to:
- Dr. Inas Khayal (Project Supervisor)
- Dr. Noelle Kosarek (Inspiration and feedback)
- Dr. Michael Whitfield (PhD advisor)
- Classmates: David, Hong, and William

## 📄 Citation

If you use SCREENER or base research off this app, please cite:
> Gong, Zhiyun. *SCREENER: A Tool for Visualizing SSc and Environmental Exposure*. QBS 192 Final Report. Dartmouth College, 2023.
