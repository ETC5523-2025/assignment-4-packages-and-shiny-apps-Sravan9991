# bushfireRisk <img src="man/figures/logo.png" align="right" height="139" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/ETC5523-2025/assignment-4-packages-sravan9991/workflows/R-CMD-check/badge.svg)](https://github.com/ETC5523-2025/assignment-4-packages-sravan9991/actions)
<!-- badges: end -->

## Overview

The `bushfireRisk` package provides tools and data for analyzing the attribution of Australian bushfire risk to anthropogenic climate change. Based on research by Oldenborgh et al. (2021), this package helps users explore how human-caused climate change has increased bushfire risk in Australia, particularly in south-eastern regions.

### Key Features

- **Interactive Shiny Dashboard**: Explore bushfire risk data through an intuitive web interface
- **Clean Datasets**: Ready-to-use data on Fire Weather Index, regional fire risk, and climate attributions
- **Visualization Functions**: Create publication-ready plots of bushfire risk trends
- **Educational Vignettes**: Learn about climate attribution science and bushfire analysis

## Installation

You can install the development version of bushfireRisk from GitHub:

```r
# install.packages("remotes")
remotes::install_github("ETC5523-2025/assignment-4-packages-sravan9991")
```

## Quick Start

### Launch the Interactive App

The easiest way to explore the data is through the interactive Shiny application:

```r
library(bushfireRisk)

# Launch the interactive dashboard
launch_bushfire_app()
```

### Work with the Data

```r
library(bushfireRisk)
library(ggplot2)
library(dplyr)

# Load the bushfire risk dataset
data("bushfire_data")

# Explore regional differences
bushfire_data %>%
  filter(region == "Southeast Australia") %>%
  ggplot(aes(x = year, y = ffdi_mean)) +
  geom_line() +
  geom_smooth(method = "lm", se = TRUE) +
  labs(title = "Fire Danger Trends in Southeast Australia",
       x = "Year", y = "Forest Fire Danger Index")

# Use helper functions
calculate_risk_change(bushfire_data, "Southeast Australia", 1950, 2020)
```

## Data Sources

This package includes data derived from:

- Oldenborgh, G.J., Philip, S.Y., Kew, S.F., van der Wiel, K., et al. (2021). Attribution of the Australian bushfire risk to anthropogenic climate change. *Environmental Research Letters*.
- Australian Bureau of Meteorology climate records
- Forest Fire Danger Index (FFDI) historical data

## Package Website

For detailed documentation, tutorials, and function references, visit the package website:

**[https://etc5523-2025.github.io/assignment-4-packages-sravan9991/](https://etc5523-2025.github.io/assignment-4-packages-sravan9991/)**

## Main Components

### Datasets

- `bushfire_data`: Comprehensive bushfire risk metrics by region and year
- `climate_attribution`: Attribution analysis results comparing natural vs. anthropogenic scenarios
- `regional_summary`: Summary statistics for Australian regions

### Functions

- `launch_bushfire_app()`: Launch the interactive Shiny dashboard
- `calculate_risk_change()`: Calculate percentage change in fire risk over time
- `plot_ffdi_trend()`: Create time-series plots of Fire Danger Index
- `compare_regions()`: Compare bushfire risk across multiple regions

### Shiny App Features

The interactive dashboard includes:

- **Regional Explorer**: Compare fire risk across different Australian regions
- **Time Series Analysis**: Visualize trends in fire danger over decades
- **Attribution Results**: Explore how climate change has altered fire risk
- **Data Export**: Download filtered data for your own analysis

## Learning Resources

The package includes several vignettes:

```r
# View available vignettes
browseVignettes("bushfireRisk")

# Key vignettes:
vignette("introduction", package = "bushfireRisk")
vignette("climate-attribution", package = "bushfireRisk")
vignette("using-the-app", package = "bushfireRisk")
```

## Citation

If you use this package in your research, please cite:

```
Kapu Bejjala, S.K. (2025). bushfireRisk: Australian Bushfire Risk Analysis 
and Visualization. R package version 0.1.0.
https://github.com/ETC5523-2025/assignment-4-packages-sravan9991
```

And the underlying research:

```
Oldenborgh, G.J., Philip, S.Y., Kew, S.F., van der Wiel, K., et al. (2021). 
Attribution of the Australian bushfire risk to anthropogenic climate change. 
Environmental Research Letters.
```

## Getting Help

- **Bug reports**: [GitHub Issues](https://github.com/ETC5523-2025/assignment-4-packages-sravan9991/issues)
- **Questions**: Open a discussion on GitHub
- **Documentation**: Visit the [package website](https://etc5523-2025.github.io/assignment-4-packages-sravan9991/)

## Related Work

This package builds on analysis from:

- Assignment 1: Breaking Down Communication Articles
- Assignment 2: Technical Report on Bushfire Attribution
- Assignment 3: Data Communication Blog

## License

MIT © Sravan Kumar Kapu Bejjala

## Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
