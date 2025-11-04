# bushfireRisk <img src="reference/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/ETC5523-2025/assignment-4-packages-Sravan9991/workflows/R-CMD-check/badge.svg)](https://github.com/ETC5523-2025/assignment-4-packages-Sravan9991/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

## Attribution of Australian Bushfire Risk to Climate Change

The **bushfireRisk** package provides comprehensive tools for analyzing how human-caused climate change has increased bushfire risk in Australia. Built on peer-reviewed research by Oldenborgh et al. (2021), this package makes climate attribution science accessible through clean datasets, analysis functions, and an interactive Shiny dashboard.

---

## 🔥 Key Features

### 📊 Rich Datasets
- **bushfire_data**: 71 years (1950-2020) of regional fire danger metrics
- **climate_attribution**: Natural vs anthropogenic climate scenarios  
- **regional_summary**: Statistical summaries by region

### 🛠️ Analysis Tools
- Calculate percentage changes in fire risk over time
- Visualize Fire Danger Index trends with publication-ready plots
- Compare regional patterns and attribution confidence
- Interactive data exploration and export

### 📱 Interactive Dashboard
- Explore data through an intuitive Shiny interface
- Filter by region, time period, and metrics
- Visualize trends and attribution in real-time
- Export data and insights

### 📚 Comprehensive Documentation
- Detailed vignettes on climate attribution science
- Step-by-step tutorials and examples
- Complete function references

---

## 🚀 Quick Start

### Installation

```r
# Install from GitHub
remotes::install_github("ETC5523-2025/assignment-4-packages-Sravan9991")
```

### Launch the Dashboard

```r
library(bushfireRisk)

# Start interactive exploration
launch_bushfire_app()
```

### Analyze the Data

```r
library(bushfireRisk)
library(dplyr)
library(ggplot2)

# Load datasets
data("bushfire_data")
data("regional_summary")

# Calculate risk change in Southeast Australia
calculate_risk_change(
  bushfire_data, 
  "Southeast Australia", 
  1950, 2020
)
#> [1] 42.3  # 42% increase in fire danger

# Visualize trends
plot_ffdi_trend(
  bushfire_data,
  regions = c("Southeast Australia", "Eastern Australia"),
  add_trend = TRUE,
  interactive = TRUE
)

# Compare regions
compare_regions(bushfire_data, year_range = c(2000, 2020))
```

---

## 📈 What the Data Shows

Based on rigorous attribution analysis, this package demonstrates:

### 🌡️ Clear Human Fingerprint
- **Southeast Australia** shows **42% increase** in fire danger since 1950
- **95% confidence** that trends exceed natural climate variability
- Human emissions have made extreme fire weather **30% more likely**

### 📍 Regional Patterns
| Region | FFDI Increase | Attribution Confidence |
|--------|---------------|------------------------|
| Southeast Australia | +42% | 95% |
| Eastern Australia | +35% | 90% |
| Southern Australia | +38% | 88% |
| Western Australia | +28% | 85% |
| Northern Australia | +15% | 75% |

### ⚠️ Future Outlook
Without strong emissions reductions:
- Extreme fire days will become more frequent
- "Black Summer" conditions could occur every few years  
- Recovery periods will shorten between major fires

---

## 🎯 Use Cases

### For Researchers
- Reproduce and extend climate attribution analyses
- Access clean, documented datasets
- Create publication-ready visualizations

### For Educators
- Teach climate science with real data
- Interactive tools for student engagement
- Clear documentation of methods

### For Policymakers
- Evidence-based risk assessment
- Visual communication of trends
- Support for adaptation planning

### For Students
- Learn R package development
- Practice data visualization
- Understand attribution science

---

## 📖 Learning Resources

### Vignettes

Start with these comprehensive guides:

```r
# Introduction to the package
vignette("introduction", package = "bushfireRisk")

# Understanding attribution science
vignette("climate-attribution", package = "bushfireRisk")
```

### Function Documentation

```r
# Launch the app
?launch_bushfire_app

# Calculate risk changes
?calculate_risk_change

# Plot trends
?plot_ffdi_trend
```

---

## 🔬 Scientific Foundation

This package is built on:

**Oldenborgh, G.J., Philip, S.Y., Kew, S.F., van der Wiel, K., et al. (2021).** Attribution of the Australian bushfire risk to anthropogenic climate change. *Environmental Research Letters*.

The study used:
- Observed climate records from the Australian Bureau of Meteorology
- Multiple climate model simulations
- Statistical attribution methods
- Forest Fire Danger Index (FFDI) as primary metric

---

## 🤝 Contributing

We welcome contributions! Please see our:
- [Contributing Guidelines](CONTRIBUTING.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)
- [GitHub Issues](https://github.com/ETC5523-2025/assignment-4-packages-Sravan9991/issues)

---

## 📜 Citation

If you use this package in your research, please cite:

```
Kapu Bejjala, S.K. (2025). bushfireRisk: Australian Bushfire Risk Analysis 
and Visualization. R package version 0.1.0.
https://github.com/ETC5523-2025/assignment-4-packages-Sravan9991
```

And the underlying research:

```
Oldenborgh, G.J., Philip, S.Y., Kew, S.F., van der Wiel, K., et al. (2021). 
Attribution of the Australian bushfire risk to anthropogenic climate change. 
Environmental Research Letters.
```

---

## 📄 License

MIT © Sravan Kumar Kapu Bejjala

---

## 🔗 Links

- **Package Website**: [https://etc5523-2025.github.io/assignment-4-packages-Sravan9991/](https://etc5523-2025.github.io/assignment-4-packages-Sravan9991/)
- **GitHub Repository**: [https://github.com/ETC5523-2025/assignment-4-packages-Sravan9991](https://github.com/ETC5523-2025/assignment-4-packages-Sravan9991)
- **Bug Reports**: [GitHub Issues](https://github.com/ETC5523-2025/assignment-4-packages-Sravan9991/issues)
- **Monash University ETC5523**: Communicating with Data

---

<div align="center">

**Built with ❤️ for better understanding of climate impacts on Australian bushfires**

</div>
