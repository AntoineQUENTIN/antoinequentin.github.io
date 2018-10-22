
+++
showonlyimage = false
draft = false
image = "img/portfolio/Bord_de_la_Marne.jpg"
date = "2016-11-05T18:25:22+05:30"
title = "Modélisation du fond géochimique sur le bassin de la Seine"
weight = 0
+++
Projet réaliser pour l'Agence de l'Eau Seine Normandie.
<!--more-->

<b>Résumé </b>

En établissant les normes de qualité environnementale (NQE) pour évaluer la qualité de l'eau en 2008, la Commission européenne a introduit parallèlement la notion de fond géochimique pour les métaux dissous dans les eaux de surface. Celui-ci soustrait à la concentration mesurée permet de faire la distinction entre l'influence de l'activité humaine et la part d’origine naturelle pour l’évaluation de l’état.

La nature géologique et les processus d'altération sont les principaux moteurs de la variabilité spatiale naturelle. L’objectif de l’étude est de déterminer les niveaux de fond géochimique pour les quatre métaux polluants spécifiques de l’état écologique (As, Cr, Cu, Zn) et les quatre métaux de l’état chimique (Cd, Hg, Ni, Pb) sur le bassin Seine-Normandie. La méthode consiste à utiliser les prélèvements de stations faiblement impactées par les activités humaines et d’interpoler leur valeur à l’ensemble du bassin. La première étape de ce travail est une analyse des données compilées par l’Agence de l’eau Seine Normandie, entre 2005 et 2018 pour ne garder que les plus qualitatives. Puis, la définition d’une liste de masse d’eau peu ou pas affectées par les activités humaines via l’occupation du sol et par la présence de sites polluants. 

Et pour finir, l’interpolation d’une moyenne représentative des stations par Kriging à l’ensemble du bassin. Un fond géochimique est ensuite moyenné à la masse d’eau associée avec un niveau de confiance. Parmi les huit métaux, l'arsenic (As) montre les meilleurs résultats. Son modèle de variogramme ayant un bon indice de corrélation, lui-même obtenu grâce à la haute densité et la répartition homogène des stations de mesure sur le bassin. Cette densité et distribution sont possibles par une identification plus précise des sources de pollution, plus difficile chez les autres métaux. La carte de l'arsenic est proche des résultats de fond géochimique sur sédiments et le retrait du fond géochimique des concentrations mesurées fait passer de mauvais à bon l’état des masses présentes (entre autres) sur les zones de socle du bassin comme le Cotentin, le Morvan.


___

<b> Calcul d'un pourcentage d'occupation du sol 'naturel' par surface </b> 

Afin d’identifier des niveaux de concentration se rapprochant des niveaux du fond géochimique, il est important de s’affranchir des pressions anthropiques. La base de données géographique Corine Land Cover (CLC) est un inventaire biophysique de l’occupation des sols qui fournit une information de référence. Un pourcentage d’occupation du sol par classe Corine Land Cover a été calculé par bassin versant de masse d’eau. Puis les masses d’eau dont la classe « territoires artificiels » dépassait 5% d’occupation totale ont été exclues. Il n’existe pas de bassin versant de masse d’eau ayant 0% d’occupation territoires artificiels sur le bassin Seine Normandie. Chacune d’entre elles est traversée à minima par une infrastructure routière. Une étude de distribution a été effectuée entre le pourcentage de territoire artificialisé et le nombre de masses d’eau disponible après exclusion. 5% offrent un nombre de masses d’eau restant suffisant, au moins la moitié est conservée pour un risque acceptable de pollution. 

 <i>Ci-dessous la partie du code calculant le pourcentage d'occupation du sol 'naturel' par surface </i>
 
```{r}
MEbassin <- st_read("BV_ME.shp") 

# Chargement du shapefile Corine land cover (Clc)
Clc <- st_read("20120912_1812_BASSIN_EXT_CORINE_LAND_COVER.shp")
Clc$CODE_06 <- as.numeric(as.character(Clc$CODE_06))
varClc_nature <- c(133:523)
varClc_per <- 95
Clcnature <- Clc[Clc$CODE_06 %in% varClc_nature,]

# Fonction intersection puis conversion en tibble
INT_amont_nature <- as_tibble(st_intersection(Clcnature, MEbassin))

# Ajoute une colonne area d'intersection pour chaque type de ClC intersect? au tibble
INT_amont_nature$area_naturel <- st_area(INT_amont_nature$geometry)

# Groupe les données par MEbassin area et calcul la surface total Clcnature area par MEbassin
# sorti comme nouveau tibble
INT_amont_nature <- INT_amont_nature %>%  group_by(EU_CD) %>%  summarise(area_naturel = sum(area_naturel))

# Change la classe des données en numeric (from 'S3: units' with m^2 suffix)
INT_amont_nature$area_naturel <- as.numeric(INT_amont_nature$area_naturel)
INT_amont_nature <- merge(x=INT_amont_nature,y=MEbassin,all.X=T)
INT_amont_nature$area_naturel <- INT_amont_nature$area_naturel*10^-6
INT_amont_nature$pourcentage_recouvrement <- INT_amont_nature$area_naturel/INT_amont_nature$AREA_Km2*100
INT_amont_nature <- subset(INT_amont_nature,pourcentage_recouvrement<100)
INT_amont_nature <- subset(INT_amont_nature,pourcentage_recouvrement>varClc_per)

```
___

<b> Kriging et parallèlisation de l'interpolation </b>

L’étude du fond géochimique est complexe dans le sens où elle croise deux délimitations spatiales distinctes, le bassin versant hydrologique et l’unité géologique. Le bassin sédimentaire parisien en forme de pile d’assiettes croise quasiment tous les bassins versants principaux à la perpendiculaire. Restreindre l’interpolation dans l’une ou l’autre de ces emprises spatiales interdit des influences locales pourtant réelles. L’interpolation par la méthode du Kriging a été laissée libre à 360°. Plusieurs modèles de variogramme sont testés : sphérique, exponentiel, gaussienne, covariance de Matérn et le plus performant vis-à-vis de la Somme des Carrés des Résidus (SSR) est utilisé pour le variogramme. Plus la SSR est proche de zéro, plus le modèle décrit la variance en fonction de la distance. Les paramètres du Krigeage sont déterminés automatiquement (nugget, sill, rang, kappa.range) par l’optimisation de la SSR et pour l’ensemble du bassin. L’interpolation se fait sur une grille rectangulaire aux dimensions du bassin Seine Normandie dont les mailles font environ 1 km². Pour une masse d’eau considérée, le résultat est représenté par la moyenne de l’ensemble des mailles interceptant ces limites. Cette moyenne à la masse d’eau permet de prend en compte leur hétérogénéité. Certaines se trouvant sur plusieurs hydro-éco-région (Wasson, 2002). 

 <i> Ci-dessous la partie du code du kriging et de la parallélisation de l'interpolation, à partir des moyennes à la station. La parallélisation est nécessaire pour diviser par 4 le temps d'interpolation et permettant ainsi de multiplié les tests.  </i>
 

```{r}
variogramme <- variogram(varD ~1, Stations.selectionnees) # calculates sample variogram values 
# best fit from the (0.3, 0.4, 0.5. ... , 5) sequence:
model.variogramme <- fit.variogram(variogramme, vgm(c("Sph","Exp","Mat","Gau")), fit.kappa = TRUE)
plotmodel <-plot(variogramme, model.variogramme,main=paste("SSErr =",round(attr(model.variogramme, "SSErr"),digits = 8)))


# Initiate cluster 
no_cores <- detectCores() 
cl <- makeCluster(getOption("cl.cores", no_cores))
parts <- split(x = 1:length(grd), f = 1:no_cores)
clusterExport(cl = cl, varlist = c("Stations.selectionnees", "grd","parts", "varD", "model.variogramme"), envir = .GlobalEnv)
clusterEvalQ(cl = cl, expr = c(library('sp'), library('gstat')))
parallelX <- parLapply(cl = cl, X = 1:no_cores, fun = function(x)krige(varD ~ 1, Stations.selectionnees, grd[parts[[x]],], model=model.variogramme))
stopCluster(cl)
# Merge the predictions    
mergeParallelX <- maptools::spRbind(parallelX[[1]], parallelX[[2]])
mergeParallelX <- maptools::spRbind(mergeParallelX, parallelX[[3]])
mergeParallelX <- maptools::spRbind(mergeParallelX, parallelX[[4]])

# Create SpatialPixelsDataFrame from mergeParallelX
Interpolation.kriging <- SpatialPixelsDataFrame(points = mergeParallelX, data = mergeParallelX@data)

```

<i> Les résultats sous forme de carte grâce à Mapview</i>

<iframe src='/img/mapview_station_arsenic_mean.html' width="100%" height="800" ></iframe>
