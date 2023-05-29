spdh_presence <- read.csv("D:/Data_analyse/Campylobacter/spdh_presence.csv")

spdh_presence$Percentage.presence = as.numeric(gsub("[\\%,]", "", spdh_presence$Percentage.presence))
spdh_presence

install.packages("car")
library(tidyverse)
library(car)
install.packages("mdthemes")
library(ggtext)
library(mdthemes)
install.packages("devtools")
devtools::install_github("kassambara/ggpubr")
library(ggpubr)

shapiro.test(spdh_presence$Percentage.presence)

spdh_presence %>%
  group_by(Kind) %>%
  summarise(p.value.sw = shapiro.test(Percentage.presence)$p.value)

wilcox.test(Percentage.presence ~ Kind, data = spdh_presence)
leveneTest(spdh_presence$Percentage.presence, as.factor(spdh_presence$Kind), center = mean)


tssD_presence <- read.csv("D:/Data_analyse/Campylobacter/tssD_presence.csv")

tssD_presence$Percentage.presence = as.numeric(gsub("[\\%,]", "", tssD_presence$Percentage.presence))
tssD_presence

install.packages("car")
library(tidyverse)
library(car)
shapiro.test(tssD_presence$Percentage.presence)

tssD_presence %>%
  group_by(Kind) %>%
  summarise(p.value.sw = shapiro.test(Percentage.presence)$p.value)

wilcox.test(Percentage.presence ~ Kind, data = tssD_presence)
leveneTest(tssD_presence$Percentage.presence, as.factor(tssD_presence$Kind), center = median)


DMSOR_presence <- read.csv("D:/Data_analyse/Campylobacter/DMSOR_presence.csv")

DMSOR_presence$Percentage.presence = as.numeric(gsub("[\\%,]", "", DMSOR_presence$Percentage.presence))
DMSOR_presence

install.packages("car")
library(tidyverse)
library(car)
shapiro.test(DMSOR_presence$Percentage.presence)

DMSOR_presence_non <- DMSOR_presence[-c(9,10,14,18,27,28),]
DMSOR_presence_non

DMSOR_presence_jejuni <- DMSOR_presence[-c(19:28),]
DMSOR_presence_coli <- DMSOR_presence[-c(1:18),]

DMSOR_presence_coli
DMSOR_presence_jejuni


DMSOR_presence_non %>%
  group_by(Kind, Species) %>%
  summarise(p.value.sw = shapiro.test(Percentage.presence)$p.value)

wilcox.test(Percentage.presence ~ Kind, data = DMSOR_presence_coli)
leveneTest(DMSOR_presence_coli$Percentage.presence, as.factor(DMSOR_presence_coli$Kind), center = median)


t.test(formula = Percentage.presence ~ Kind, data = DMSOR_presence_jejuni, paired = FALSE, var.equal = TRUE)
leveneTest(DMSOR_presence_jejuni$Percentage.presence, as.factor(DMSOR_presence_jejuni$Kind), center = median)

spdh_results <- read.delim("D:/Data_analyse/Campylobacter/spdh_results", sep = "\t")
spdh_results
spermidine = c("0 mM spd", "0 mM spd", "0 mM spd", "0 mM spd", "0.5 mM spd", "0.5 mM spd", "0.5 mM spd", "0.5 mM spd", "1 mM spd", "1 mM spd", "1 mM spd", "1 mM spd")
spdh_results$spermidine = spermidine


spdh_a <- spdh_results %>%
  group_by(time, as.factor(spermidine)) %>%
  ggplot(aes(x = time, y = average)) +
  geom_line(aes(colour = spermidine), size = .8) +
  geom_point(aes(colour = spermidine)) +
  geom_errorbar(aes(ymin = average - st_dev, ymax = average + st_dev, colour = spermidine),
                width = .2) +
  mdthemes::md_theme_classic() +
  labs(title = "*C. jejuni* 22S00880-1 *spdH* -ve DUF2165 +ve",
       x = "Time in hours",
       y = "OD600")
  

spdh_d <- spdh_results %>%
  group_by(time, as.factor(spermidine)) %>%
  ggplot(aes(x = time, y = average)) +
  geom_line(aes(colour = spermidine), size = .8) +
  geom_point(aes(colour = spermidine)) +
  geom_errorbar(aes(ymin = average - st_dev, ymax = average + st_dev, colour = spermidine),
                width = .2) +
  mdthemes::md_theme_classic()

ggarrange(spdh_a, spdh_b, spdh_c, spdh_d, labels = c("A", "B", "C"))


library(scales)
library(lubridate)

