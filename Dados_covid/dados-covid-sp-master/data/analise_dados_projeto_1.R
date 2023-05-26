# BUSCAR DIRETÓRIO (PASTA COM OS ARQUIVOS)
setwd("D:/Mestrado/Linguagem_R-Projeto_1/Dados_covid/dados-covid-sp-master/data")

library(dplyr)

# ABRIR ARQUIVO
covid_sp_tratado <- read.csv('covid_sp_tratado.csv', sep = ",")
covid_sp_tratado['area'] <- covid_sp_tratado$area/100
covid_sp_tratado['dens_demografica'] <- covid_sp_tratado$pop/covid_sp_tratado$area

covid_sp_tratado['data'] <- as.Date(covid_sp_tratado$data, format('%Y-%m-%d'))

covid_campinas <- covid_sp_tratado %>% filter(municipio=="Campinas")

covid_botucatu <- covid_sp_tratado %>% filter(municipio== "Botucatu")

covid_areiopolis <- covid_sp_tratado %>% filter(municipio=="Areiópolis")

#gráfico