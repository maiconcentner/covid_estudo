#? CARREGANDO PACOTES
library(dplyr)
library(rstatix)
library(ggplot2)
library(plotly)
library(graphics)

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

########

#? ANALISE GRAFICA
#? CONTAGEM COLUNA CS_SEXO
table(srag_sp_mod$sexo)

#? GRAFICO DE BARRAS USANDO BARPLOT
grafico_barras = table(srag_sp_mod$sexo)
grafico_barras %>% 
  barplot(col = 'yellow', main = 'Quantidade por sexo')

#? GRAFICO DE BARRAS COM GGPLOT2
srag_sp_mod %>% 
  ggplot(aes(x = sexo))+
    geom_bar(fill = 'red')+
      labs(title = "Quantidade por sexo", 
           subtitle = "SRAG", 
           x = "Sexo", y = "Contagem")

#? GRAFICO POR RACA
srag_sp_mod %>% 
  sapply(function(x) sum(is.na(x))) #verificando dados vazios

#? preenchendo os dados NA como IGNORADOS
srag_sp_mod$CS_RACA[which(is.na(srag_sp_mod$CS_RACA))] <- 9

#alterando os valores pelos nomes que constam no dicionario da base
srag_sp_mod$CS_RACA[srag_sp_mod$CS_RACA == 1] <- "Branca"
srag_sp_mod$CS_RACA[srag_sp_mod$CS_RACA == 2] <- "Preta"
srag_sp_mod$CS_RACA[srag_sp_mod$CS_RACA == 3] <- "Amarela"
srag_sp_mod$CS_RACA[srag_sp_mod$CS_RACA == 4] <- "Parda"
srag_sp_mod$CS_RACA[srag_sp_mod$CS_RACA == 5] <- "Indígena"
srag_sp_mod$CS_RACA[srag_sp_mod$CS_RACA == 9] <- "Ignorado"


















