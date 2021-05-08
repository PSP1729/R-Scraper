library(rvest)
library(magrittr)
library(dplyr)
library(stringr)
library(tibble)
links <- c()
for(i in 1:439){
  url <-paste0("https://animesuge.io/az-list?page=",i)
  rawl <-read_html(url)
  linklist <- rawl%>%
    html_nodes(".content ul li a") %>%
    html_attr("href") %>% unique() %>%
    paste0("https://animesuge.io",.)
  links <- c(links,linklist)
}
html <- lapply(links,function(h){
  read_html(h)
})
name_raw <- lapply(html, function(l){
  l %>%
    html_nodes(".info h2") %>%
    html_text()
})
disc_raw <- lapply(html, function(l){
  l %>%
    html_nodes(".info p") %>%
    html_text()
})
otn_raw <- lapply(html, function(l){
  l %>%
    html_nodes(".alias") %>%
    html_text()
})
meta1 <- lapply(html, function(l){
  l %>%
    html_nodes(".col1 div span") %>%
    html_text()
})
meta2 <- lapply(html, function(l){
  l %>%
    html_nodes(".col2 div span") %>%
    html_text()
})
type_raw <- lapply(meta1, function(m){
  m[1]
})
stu_raw <- lapply(meta1, function(m){
  m[2]
})
air_raw <- lapply(meta1, function(m){
  m[3]
})
stat_raw <- lapply(meta1, function(m){
  m[4]
})
genre_raw <- lapply(meta2, function(m){
  m[1]
})
country_raw <- lapply(meta2, function(m){
  m[2]
})
time_raw <- lapply(meta2, function(m){
  m[3]
})
dur_raw <- lapply(meta2, function(m){
  m[4]
})
names<-unlist(name_raw) %>%
  str_remove_all(.,"\"")
disc <- unlist(disc_raw) %>% str_trim()
type <- unlist(type_raw) %>% str_trim()
stu <- unlist(stu_raw) %>% str_trim()
air <- unlist(air_raw) %>% str_trim()
stat <- unlist(stat_raw) %>% str_trim()
country <- unlist(country_raw) %>% str_trim()
time <- unlist(time_raw) %>% str_trim()
dur <- unlist(dur_raw) %>% str_trim()
otn <- unlist(otn_raw) %>%
  str_remove(.,"Other names: ")
genre <- unlist(genre_raw) %>% str_trim()
df <- data.frame(
  Names = paste0("\"",names,"\""),
  GenresList = genre,
  Type = type,
  Aired = air,
  Studio = stu,
  Country = country,
  Season = time,
  Duration = dur,
  Status = stat,
  Synopsis = disc,
  OtherNames = otn
)
write.csv(df,"animesuge.csv")