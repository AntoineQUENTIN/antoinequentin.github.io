
+++
showonlyimage = false
draft = false
image = "img/portfolio/data.viz.png"
date = "2016-11-05T18:25:22+05:30"
title = "Visualisation de données"
weight = 0
+++
Voici quelques exemples de ce qu'on peut faire avec R
<!--more-->

R permet de faire bien plus que de la simple statistique grâce à une bibliothèque de package très fournie et une communauté active. Voici un échantillon des possibilités trouver sur le web et publier grâce à <a href="https://bookdown.org/yihui/blogdown/">`Blogdown`</a> et <a href="https://www.htmlwidgets.org/">`Htmlwidgets`</a>.


___
`NetworkD3` permet de créer des graphiques de réseau à partir de javascript D3.
https://christophergandrud.github.io/networkD3/

```{r}
 library(networkD3)
 # Create fake data
 src <- c("A", "A", "A", "A","B", "B", "C", "C", "D")
 target <- c("B", "C", "D", "J","E", "F", "G", "H", "I")
 networkData <- data.frame(src, target)
 simpleNetwork(networkData)
```
<iframe src='/img/fig/DiagrammeR.html' width="100%" height="400" frameborder="0" scrolling="no" ></iframe>


```{r}
 URL <- c("https://cdn.rawgit.com/christophergandrud/networkD3/master/JSONdata//flare.json")
 Flare <- jsonlite::fromJSON(URL, simplifyDataFrame = FALSE)
 Flare$children = Flare$children[1:3]
 radialNetwork(List = Flare, fontSize = 10, opacity = 0.9)
```
<iframe src='/img/fig/radialNetwork.html' width="100%" height="400" frameborder="0" scrolling="no" ></iframe>


```{r}
 diagonalNetwork(List = Flare, fontSize = 10, opacity = 0.9)
 ```
<iframe src='/img/fig/diagonalNetwork.html' width="100%" height="400" frameborder="0" scrolling="no" ></iframe>


```{r}
 URL <- paste0(
   "https://cdn.rawgit.com/christophergandrud/networkD3/",
   "master/JSONdata/energy.json")
 Energy <- jsonlite::fromJSON(URL)
 sankeyNetwork(Links = Energy$links, Nodes = Energy$nodes, Source = "source",
               Target = "target", Value = "value", NodeID = "name",
               units = "TWh", fontSize = 12, nodeWidth = 30)
```
<iframe src='/img/fig/sankeyNetwork.html' width="100%" height="400" frameborder="0" scrolling="no" ></iframe>


___
`VisNetwork` fournit une interface de la bibliothèque vis.js pour visualiser les réseaux  
https://datastorm-open.github.io/visNetwork
```{r}
  library(visNetwork)
  nodes <- data.frame(id = 1:6, title = paste("node", 1:6), 
                      shape = c("dot", "square"),
                      size = 10:15, color = c("blue", "red"))
  edges <- data.frame(from = 1:5, to = c(5, 4, 6, 3, 3))
  visNetwork(nodes, edges) %>%
    visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE)
```
<iframe src='/img/fig/visNetwork.html' width="100%" height="600" frameborder="0" scrolling="no"></iframe>


___
`D3heatmap` permet de faire des cartes interactives, avec notamment la mise en surbrillance et du zoom de lignes et colonnes.
https://github.com/rstudio/d3heatmap"

```{r}
 library(d3heatmap)
  d3heatmap(mtcars, scale="column", colors="Blues")  
```
<iframe src='/img/fig/d3heatmap.html' width="100%" height="600" frameborder="0" scrolling="no"></iframe>



___
`Threejs` permet de manipuler un diagramme à l'aide de la souris.
https://github.com/bwlewis/rthreejs

```{r}
  library(threejs)
  z <- seq(-10, 10, 0.1)
  x <- cos(z)
  y <- sin(z)
  scatterplot3js(x,y,z, color=rainbow(length(z)))
```
<iframe src='/img/fig/threejs.html' width="100%" height="400" frameborder="0" scrolling="no"></iframe>


___
`DT` affiche les matrices R ou les cadres de données sous forme de tableaux HTML interactifs prenant en charge le filtrage, la pagination et le tri.
http://rstudio.github.io/DT

```{r}
  library(DT)
     iris2 = iris[c(1:10, 51:60, 101:110), 1:4]
  datatable(iris2,rownames = F, class = 'cell-border stripe',filter = 'top', options = list(pageLength = 5, autoWidth = TRUE,dom = 't'),width = "500px")
```
<iframe src='/img/fig/DT.html' width="100%" height="400" frameborder="0" scrolling="no"></iframe>


___
`Plot_ly` permet de traduire facilement les graphiques ggplot2 en une version Web interactive, et fournit également des liaisons à la bibliothèque graphique plotly.js.
https://plot.ly/r/"

```{r}
  library(plot_ly)
  d <- diamonds[sample(nrow(diamonds), 500), ]
  plot_ly(d, x = d$carat, y = d$price, 
          text = paste("Clarity: ", d$clarity),
          mode = "markers", color = d$carat, size = d$carat)
```
<iframe src='/img/fig/plotly.html' width="100%" height="400" frameborder="0" scrolling="no"></iframe>



