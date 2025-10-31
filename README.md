# VisuNet

<img src="images/VIsuNet_logo2.png" width=200; align="middle">



*** 
VisuNet is an interactive tool for network visualization of complex rule-based classifiers. VisuNet can be applied to any classification problem and is commonly used with complex health-related decision tasks. The rule networks produced can clearly identify driving genes (metabolites, methylation sites, etc) and their expression levels. 

VisuNet is implemented in R and uses the  [Shiny Gadgets](https://shiny.rstudio.com/articles/gadgets.html) attributes. The tool includes construction, filtration, visualization and customization of networks from rule-based models.

***
Installation
```R
devtools::install_github("komorowskilab/VisuNet")
```

***
## Recent Updates

### Node Size Aggregation Methods

VisuNet supports different aggregation methods for calculating node sizes. You can choose how to aggregate support/decision coverage values across rules for each node:

- `"sum"` (default): Use the sum of support/decision coverage values
- `"mean"`: Use the mean of support/decision coverage values
- `"mx"`: Use the maximum of support/decision coverage values

**Usage Example:**
```R
# Default behavior (sum aggregation)
vis <- visunet(ros$main)

# Use mean aggregation instead
vis <- visunet(ros$main, NodeSize = "mean")

# Use maximum aggregation
vis <- visunet(ros$main, NodeSize = "mx")
```

This parameter allows for more flexible node size calculations depending on your analysis needs.

### Gene Ontology (GO) Annotations

VisuNet supports automatic Gene Ontology annotations for nodes. This feature adds functional information to your network nodes using biological pathway data.

**Parameters:**
- `addGO`: Set to `TRUE` to enable GO annotations (default: `FALSE`)
- `GO_ontology`: Ontology type - "MF" (Molecular Function), "BP" (Biological Process), "CC" (Cellular Component)

**Requirements:** This feature requires the `clusterProfiler`, `org.Hs.eg.db`, and `GO.db` packages.

**Usage Example:**
```R
# Add GO annotations using Molecular Function ontology
vis <- visunet(ros$main, addGO = TRUE, GO_ontology = "MF")

# Use Biological Process ontology
vis <- visunet(ros$main, addGO = TRUE, GO_ontology = "BP")
```

GO annotations provide additional biological context to help interpret the functional significance of genes/metabolites in your rule networks.

***
See the [documentation](https://komorowskilab.github.io/VisuNet/).
