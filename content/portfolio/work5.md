
+++
showonlyimage = false
draft = false
image = "img/portfolio/Bitcoin.price.gif"
date = "2018-11-02T18:25:22+05:30"
title = "Bitcoin animation"
weight = 0
+++
Un projet pour apprendre à utiliser `gganimate`
<!--more-->

<iframe src='/img/Bitcoin.price.gif' width="100%" height="400" frameborder="0" scrolling="no" ></iframe>


Voici la célébre courbe du Bitcoin  qui avait atteint son plus haut niveau historique en décembre 2017. Je l'ai animé avec `gganimate` en m'inspirant du travail de Jonathan Spring.

{{< tweet 1048711474468728832 >}}


Pour commencer, quelques packages sont nécessaires : `tidyverse` pour manipuler les données, `lubridate` pour gérer les dates, `gganimate`  pour l'animation de `ggplot` et `coindeskr` pour se connecter à l'API de Coindesk.


On commence par charger l'historique du prix du bitcoin

```{r}
btc.price <-get_historic_price(currency = "USD",
                              start = ymd(20150101),
                              end = as.Date(Sys.time()))
btc.price$date <- row.names(btc.price)
row.names(btc.price) <- 1:nrow(btc.price)
sample <- btc.price; sample$date <- as.Date(sample$date)
colnames(sample) <- c("value","date")
```

On simule une rotation 

```{r}
frame_count <- (max(sample$date)- min(sample$date))/lubridate::ddays(1)
cycle_length <- 365

sample3 <- map_df(seq_len(frame_count),~sample,.id = "id")%>%
  mutate(id = as.integer(id))%>%
  # view date is the 'camera' date
  mutate(view_date=min(sample$date)+id-1)%>%
  filter(date <= view_date)%>%
  mutate(days_ago=(view_date - date)/ddays(1),
         phase_dif = (days_ago %% cycle_length)/ cycle_length,
         x_pos = -sin(2*pi * phase_dif),
         nearness= cos(2*pi * phase_dif),
         rowname=row.names(sample3),
         month.year=paste(month(date,label = T,abbr = T,locale = "US"),year(date),sep="-"))
```


On rajoute les dates dans la rotation /!\ sans les superposées

```{r}
tmp <- sample3 %>% 
       group_by(id,month.year) %>% 
       summarise(min = min(nearness),rowname=max(rowname)) %>%
       group_by(id)%>%
       mutate(test = case_when(max(as.numeric(rowname)) >= as.numeric(rowname)+cycle_length ~ 1, TRUE ~ 2 ))%>%
       filter(test == 2)
  
sample3$month.year <-  left_join(sample3,tmp, by = "rowname")[,12]
sample3$month.year <- ifelse(sample3$nearness!=1,sample3$month.year,NA)
```

Puis on plot et on anime

```{r}
bit.anim <- ggplot(sample3)+
  geom_path(aes(x_pos, value, alpha=nearness,color=days_ago))+
  geom_text(aes(x_pos, -2000,label=month.year,alpha=nearness))+
  scale_size(range = c(0,2))+
  transition_manual(id) +theme_void()+
  guides(size="none",alpha="none",color="none")
 
animate(anim, fps=30, duration=60, width=600, height=400)
```
