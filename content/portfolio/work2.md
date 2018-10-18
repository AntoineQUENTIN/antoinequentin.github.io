
+++
showonlyimage = true
draft = false
image = "img/portfolio/data.viz.png"
date = "2016-11-05T18:25:22+05:30"
title = "Data viz"
weight = 0
+++

Exemple de data viz avec R
<!--more-->

```{r 01}
library(threejs)
z <- seq(-10, 10, 0.1)
x <- cos(z)
y <- sin(z)
scatterplot3js(x,y,z, color=rainbow(length(z)))
```
<iframe src='/img/threejs.html' width="100%" height="400"></iframe>

