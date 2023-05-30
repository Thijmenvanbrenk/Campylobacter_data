# activate packages
library(tidyverse)
library(car)
library(mdthemes)

# read raw data
spdh_presence <- read.csv("D:/Data_analyse/Campylobacter_data/Raw_data/spdH/spdh_presence.csv")
tssD_presence <- read.csv("D:/Data_analyse/Campylobacter_data/Raw_data/T6SS/tssD_presence.csv")
DMSOR_presence <- read.csv("D:/Data_analyse/Campylobacter_data/Raw_data/DMSOR/DMSOR_presence.csv")

# tidy up percentages
spdh_presence$Percentage.presence = as.numeric(gsub("[\\%,]", "", spdh_presence$Percentage.presence))
spdh_presence

tssD_presence$Percentage.presence = as.numeric(gsub("[\\%,]", "", tssD_presence$Percentage.presence))
tssD_presence

DMSOR_presence$Percentage.presence = as.numeric(gsub("[\\%,]", "", DMSOR_presence$Percentage.presence))
DMSOR_presence


# statistical analysis spdh, 
spdh_presence %>%
  group_by(Kind) %>%
  summarise(p.value.sw = shapiro.test(Percentage.presence)$p.value)
leveneTest(spdh_presence$Percentage.presence, as.factor(spdh_presence$Kind), center = mean)

# not normally distributed so mann whitney U test, equal variance = true
wilcox.test(Percentage.presence ~ Kind, data = spdh_presence)


tssD_presence %>%
  group_by(Kind) %>%
  summarise(p.value.sw = shapiro.test(Percentage.presence)$p.value)
leveneTest(tssD_presence$Percentage.presence, as.factor(tssD_presence$Kind), center = median)

# not normally distributed so mann whitney U test, equal variance = true
wilcox.test(Percentage.presence ~ Kind, data = tssD_presence)


# birds and water are only 2 values per species, no normality test possible, extract all non-birds
DMSOR_presence_non <- DMSOR_presence[-c(9,10,14,18,27,28),]

# test of normality
DMSOR_presence_non %>%
  group_by(Kind, Species) %>%
  summarise(p.value.sw = shapiro.test(Percentage.presence)$p.value)

# jejuni is normally distributed, coli is not
DMSOR_presence_jejuni <- DMSOR_presence[-c(19:28),]
DMSOR_presence_coli <- DMSOR_presence[-c(1:18),]

# coli statistical analysis
leveneTest(DMSOR_presence_coli$Percentage.presence, as.factor(DMSOR_presence_coli$Kind), center = median)
wilcox.test(Percentage.presence ~ Kind, data = DMSOR_presence_coli)

# jejuni statistical analysis
leveneTest(DMSOR_presence_jejuni$Percentage.presence, as.factor(DMSOR_presence_jejuni$Kind), center = median)
t.test(formula = Percentage.presence ~ Kind, data = DMSOR_presence_jejuni, paired = FALSE, var.equal = TRUE)
