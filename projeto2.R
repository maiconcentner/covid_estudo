#? CARREGANDO PACOTES
library(dplyr)
library(rstatix)
library(ggplot2)
library(plotly)

#? SETANDO PASTA DE TRABALHO
setwd("D:\\Mestrado\\Linguagem_R-Projeto_1\\Dados_covid\\dados-covid-sp-master\\data")

#? CARREGANDO BASE DE DADOS
srag_sp <- read.csv('SRAG_2020.csv', sep = ";")

#? EXCLUINDO COLUNAS QUE NÃO IREI UTILIZAR
srag_sp_mod <- select(srag_sp, -c(51:133))
srag_sp_mod <- select(srag_sp_mod, -c(5:8))
srag_sp_mod <- select(srag_sp_mod, -c(6,8))

#? VERIFICANDO AS VARIÁVEIS
glimpse(srag_sp_mod)

#? CONVERTENDO DT_NOTIFIC PARA DATE
srag_sp_mod$DT_NOTIFIC <- as.Date(srag_sp_mod$DT_NOTIFIC, format = '%m/%d/%Y')

#? RENOMEANDO COLUNAS
srag_sp_mod <- rename(srag_sp_mod, sexo = CS_SEXO, idade = NU_IDADE_N)

#? VERIFICANDO VALORES MISSING
#NA = VALORES AUSENTES
srag_sp_mod %>% 
  sapply(function(x) sum(is.na(x)))

#NAN = VALORES INDEFINIDOS
srag_sp_mod %>% 
  sapply(function(x) sum(is.nan(x)))








