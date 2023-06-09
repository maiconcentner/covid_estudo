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

#CONTAGEM
srag_sp_mod$CS_RACA %>% 
  table()

##GGPLOT2
srag_sp_mod %>% 
  ggplot(aes(x = CS_RACA))+
    geom_bar(fill = 'blue')+
      labs(title = "Quantidade por raça",
           subtitle = "SRAG",
           x = "Raça", y = "Contagem")


#? GRÁFICO POR RAÇA, SEXO E REGIAO
# verificando valores NA

srag_sp_mod %>% 
  sapply(function(x) sum(is.na(x)))

#substituindo valores NA por 9
srag_sp_mod$CS_ZONA[which(is.na(srag_sp_mod$CS_ZONA))] <- 9

#renomeando os valores da coluna CS_ZONA
srag_sp_mod$CS_ZONA[srag_sp_mod$CS_ZONA == 1] <- "Urbana"
srag_sp_mod$CS_ZONA[srag_sp_mod$CS_ZONA == 2] <- "Rural"
srag_sp_mod$CS_ZONA[srag_sp_mod$CS_ZONA == 3] <- "Periurbana"
srag_sp_mod$CS_ZONA[srag_sp_mod$CS_ZONA == 9] <- "Ignorado"

srag_sp_mod$CS_ZONA %>% 
  table()

#? GERANDO O GRÁFICO
srag_sp_mod %>% 
  ggplot(aes(x = CS_RACA, y = sexo, fill = factor(CS_ZONA))) +
           geom_col(position = "dodge") +
           labs(title = "Região por sexo e raça",
                x = "Raça",
                y = "Sexo",
                fill = "Região")

#? GERANDO O GRÁFICO NA HORIZONTAL
srag_sp_mod %>% 
  ggplot(aes(x = CS_RACA, y = sexo, fill = factor(CS_ZONA))) +
  geom_col(position = "dodge") +
  labs(title = "Região por sexo e raça",
       x = "Raça",
       y = "Sexo",
       fill = "Região") +
coord_flip()

#? GRAFICO DE BARRAS EMPILHADO
#! apenas exemplo, analise ficou meio sem sentido

grafico <- aggregate(idade ~ sexo + CS_ZONA, data = srag_sp_mod, FUN = mean)

grafico %>% 
  ggplot(aes(x = CS_ZONA, y = idade, fill = factor(sexo))) + 
  geom_col(position = "stack")

#GRÁFICO COM O PLOTLY
srag_sp_mod %>% 
  plot_ly(x = ~CS_RACA) %>% 
    layout(xaxis = list(title = "Raça"),
           yaxis = list(title = "Quantidade"))

#? BOXPLOT PARA IDADE

#idade

srag_sp_mod$idade[srag_sp_mod$TP_IDADE == 2] <- 0 #deixando tudo em anos
srag_sp_mod$idade[srag_sp_mod$TP_IDADE == 1] <- 0 #idem

summary(srag_sp_mod$idade)
srag_sp_mod$idade %>% boxplot() #recurso do R


#identificando os outliers
srag_sp_mod %>% 
  identify_outliers(idade)

#tratando outliers
outliers <- c(boxplot.stats(srag_sp_mod$idade)$out)

#criando uma tabela sem os outliers
srag_atual <- srag_sp_mod[-c(which(srag_sp_mod$idade %in% outliers)),]

srag_atual$idade %>% summary()
srag_atual$idade %>% boxplot()


#MONTANDO NO GGPLOT2 

#com outlier
srag_sp_mod %>% 
  filter(!is.na(idade)) %>% 
    ggplot(aes(x = " ", y = idade)) +
    geom_boxplot(width = .3, outlier.colour = "purple")

#sem outlier
srag_atual %>% 
  filter(!is.na(idade)) %>% 
  ggplot(aes(x = " ", y = idade)) +
  geom_boxplot(width = .3, outlier.colour = "purple")

#COM PLOTLY

srag_atual %>% 
  plot_ly(y = srag_atual$idade,
          type = "box") %>% 
          layout(title = "BOXPLOT POR IDADE",
                 yaxis = list(title = "Idade"))


#? BOXPLOT COLETIVO

par(mfrow = c(1,2)) #graficos na mesma linha
srag_sp_mod$idade %>% boxplot(xlab = "Idade com outliers")
srag_atual$idade %>% boxplot(xlab = "Idade sem outliers")

# GRÁFICOS UMA LINHA E DUAS COLUNAS
par(mfrow=c(1,2))
boxplot(idade ~ sexo, srag_atual, ylab = "Idade", xlab = "Sexo")
boxplot(idade ~ CS_RACA, srag_atual, ylab = "Idade", xlab = "Raça")

#ggplot2
srag_atual %>% 
  ggplot(aes(x = factor(sexo), y = idade)) +
  geom_boxplot(fill = "dodgerblue") + 
  labs(y = "idade",
       x = "sexo",
       title = "Distribuição das idades por sexo")


#plotly
srag_atual %>% 
  plot_ly(y = srag_atual$idade, color = srag_atual$sexo,
          type = "box") %>% 
          layout(title = "BOXPLOT POR IDADE",
                 xaxis = list(title = "Sexo"), yaxis = list(title = "Idade"))

####

#? HISTOGRAMA PARA IDADE
srag_atual$idade %>% 
  hist(col = "blue", main = "SRAG POR IDADE",
       xlab = "Distribuição das idades", ylab = "Frequência")


srag_atual$idade %>% 
  hist(probability = T, col = "green", main = "SRAG POR IDADE")
  lines(density(srag_atual$idade), col = "red", lwd=3)#lwd aumenta a expessura

#? CRIANDO A FUNÇÃO MODA
  moda <- function(m){
    valor_unico <- unique(m) #busca o valor único para a coluna valor
    valor_unico[which.max(tabulate(match(m, valor_unico)))] #contabilizar
  }

moda(srag_atual$idade)

#QQPLOT (GRÁFICO DE DISTRIBUIÇÃO NORMAL)
srag_atual$idade %>% 
  qqnorm(col = "gray")

srag_atual$idade %>% 
  qqline(col = "red")

#verificando numericamente
library(nortest)
#teste de normalidade Shapiro-Wilk
srag_atual$idade %>% shapiro.test() #só roda entre 3 e 5000 linhas

#teste Anderson-Darling
srag_atual$idade %>% ad.test()
#!dist. não é normal


#HISTOGRAMA NO GGPLOT2
srag_atual %>% 
  ggplot(aes(x = idade))+
  geom_histogram(fill = "red", bins = 25)+
  labs(title = "Histograma da idade",
       subtitle = "SRAG",
       x = "Idade", y = "Contagem")


#COM O PLOTLY
plot_ly(x = srag_atual$idade  , type = "histogram") %>% 
  layout(title = "HISTOGRAMA POR IDADE",
         xaxis = list(title = "Idade"), yaxis = list(title = "Quantidade"))
  
  
  
  
  
  
  
  
  
  




















  
  
  
  
  
