
+++
showonlyimage = false
draft = false
image = "img/portfolio/data.viz.png"
date = "2016-11-05T18:25:22+05:30"
title = "Data viz"
weight = 0
+++

Voici quelques exemples de ce qu'on peut produire avec R
<!--more-->

```{r 01}
 URL <- paste0(
   "https://cdn.rawgit.com/christophergandrud/networkD3/",
   "master/JSONdata//flare.json")
 
 ## Convert to list format
 Flare <- jsonlite::fromJSON(URL, simplifyDataFrame = FALSE)
 
 # Use subset of data for more readable diagram
 Flare$children = Flare$children[1:3]
 
 radialNetwork(List = Flare, fontSize = 10, opacity = 0.9)
 ```
<iframe src='/img/fig/radialNetwork.html' width="100%" height="400" frameborder="0"></iframe>


```{r 01}
 diagonalNetwork(List = Flare, fontSize = 10, opacity = 0.9)
 ```
<iframe src='/img/fig/diagonalNetwork.html' width="100%" height="400" frameborder="0"></iframe>




```{r 01}
 URL <- paste0(
   "https://cdn.rawgit.com/christophergandrud/networkD3/",
   "master/JSONdata/energy.json")
 Energy <- jsonlite::fromJSON(URL)
 # Plot
 sankeyNetwork(Links = Energy$links, Nodes = Energy$nodes, Source = "source",
               Target = "target", Value = "value", NodeID = "name",
               units = "TWh", fontSize = 12, nodeWidth = 30)
```
<iframe src='/img/fig/sankeyNetwork.html' width="100%" height="400" frameborder="0"></iframe>




```{r 01}
  library(visNetwork)
  nodes <- data.frame(id = 1:6, title = paste("node", 1:6), 
                      shape = c("dot", "square"),
                      size = 10:15, color = c("blue", "red"))
  edges <- data.frame(from = 1:5, to = c(5, 4, 6, 3, 3))
  i <- visNetwork(nodes, edges) %>%
    visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE)
```
<iframe src='/img/fig/visNetwork.html' width="1000" height="600" frameborder="0"></iframe>


```{r 01}
 library(d3heatmap)
  i <-d3heatmap(mtcars, scale="column", colors="Blues")  


```
<iframe src='/img/fig/d3heatmap.html' width="1000" height="600" frameborder="0"></iframe>

```{r 01}
  library(DiagrammeR)
 i <-  grViz("
  digraph {
    layout = twopi
    node [shape = circle]
    A -> {B C D} 
  }")
```
<iframe src='/img/fig/DiagrammeR.html' width="100%" height="400" frameborder="0"></iframe>




```{r 01}
library(threejs)
z <- seq(-10, 10, 0.1)
x <- cos(z)
y <- sin(z)
scatterplot3js(x,y,z, color=rainbow(length(z)))
```
<iframe src='/img/fig/threejs.html' width="100%" height="400" frameborder="0"></iframe>

```
library(DT)
df <- datatable(iris, options = list(pageLength = 5))
```
<iframe src='/img/fig/DT.html' width="800" height="400" frameborder="0"></iframe>



```{r 01}
d <- diamonds[sample(nrow(diamonds), 500), ]
d <- plot_ly(d, x = d$carat, y = d$price, 
        text = paste("Clarity: ", d$clarity),
        mode = "markers", color = d$carat, size = d$carat)
```

<iframe src='/img/fig/plotly.html' width="100%" height="400" frameborder="0"></iframe>








