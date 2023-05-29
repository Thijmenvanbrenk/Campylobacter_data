# install packages
library(tidyverse)
library(mdthemes)
library(ggpubr)

# make for do done loop

samples_1 <- c("CvS190028", "Ca2737", "Ca56-25")
samples_2 <- c("103292-003-095", "103292-003-088", "103292-003-031", "18-572-2")
samples_3 <- c("103292-003-074")

# spdh negative duf positive
 for (sample in samples_1) {
  
  results <- read.delim(paste0("D:/Data_analyse/Campylobacter/spdh_results/spdh_results_", sample), sep = "\t")
  assign(paste0("table_", sample), results)
  
  spermidine = c("0 mM spd", "0 mM spd", "0 mM spd", "0 mM spd",
                 "0.5 mM spd", "0.5 mM spd", "0.5 mM spd", "0.5 mM spd",
                 "1 mM spd", "1 mM spd", "1 mM spd", "1 mM spd")
  
  spdh_graph <- results %>%
    group_by(time, as.factor(spermidine)) %>%
    ggplot(aes(x = time, y = average)) +
    geom_line(aes(colour = spermidine), linewidth = .8) +
    geom_point(aes(colour = spermidine)) +
    geom_errorbar(aes(ymin = average - st_dev, ymax = average + st_dev, colour = spermidine),
                  width = .2) +
    mdthemes::md_theme_classic() +
    labs(title = paste("*C. jejuni*", sample ,"*spdH* -ve DUF +ve"),
         x = "Time in hours",
         y = "OD600") +
    scale_colour_discrete(name = "Spermidine\nconcentration")
  assign(paste0("graph_", sample), spdh_graph)
  
  
 }

# spdh positive duf negative

 for (sample in samples_2) {
   
   results <- read.delim(paste0("D:/Data_analyse/Campylobacter/spdh_results/spdh_results_", sample), sep = "\t")
   assign(paste0("table_", sample), results)
   
   spermidine = c("0 mM spd", "0 mM spd", "0 mM spd", "0 mM spd",
                  "0.5 mM spd", "0.5 mM spd", "0.5 mM spd", "0.5 mM spd",
                  "1 mM spd", "1 mM spd", "1 mM spd", "1 mM spd")
   
   spdh_graph <- results %>%
     group_by(time, as.factor(spermidine)) %>%
     ggplot(aes(x = time, y = average)) +
     geom_line(aes(colour = spermidine), linewidth = .8) +
     geom_point(aes(colour = spermidine)) +
     geom_errorbar(aes(ymin = average - st_dev, ymax = average + st_dev, colour = spermidine),
                   width = .2) +
     mdthemes::md_theme_classic() +
     labs(title = paste("*C. jejuni*", sample ,"*spdH* +ve DUF -ve"),
          x = "Time in hours",
          y = "OD600") +
     scale_colour_discrete(name = "Spermidine\nconcentration")
   assign(paste0("graph_", sample), spdh_graph)
   
   
 } 
# spdh negative duf negative
 
 for (sample in samples_3) {
   
   results <- read.delim(paste0("D:/Data_analyse/Campylobacter/spdh_results/spdh_results_", sample), sep = "\t")
   assign(paste0("table_", sample), results)
   
   spermidine = c("0 mM spd", "0 mM spd", "0 mM spd", "0 mM spd",
                  "0.5 mM spd", "0.5 mM spd", "0.5 mM spd", "0.5 mM spd",
                  "1 mM spd", "1 mM spd", "1 mM spd", "1 mM spd")
   
   spdh_graph <- results %>%
     group_by(time, as.factor(spermidine)) %>%
     ggplot(aes(x = time, y = average)) +
     geom_line(aes(colour = spermidine), linewidth = .8) +
     geom_point(aes(colour = spermidine)) +
     geom_errorbar(aes(ymin = average - st_dev, ymax = average + st_dev, colour = spermidine),
                   width = .2) +
     mdthemes::md_theme_classic() +
     labs(title = paste("*C. jejuni*", sample ,"*spdH* -ve DUF -ve"),
          x = "Time in hours",
          y = "OD600") +
     scale_colour_discrete(name = "Spermidine\nconcentration")
   assign(paste0("graph_", sample), spdh_graph)
   
   
 } 


ggarrange(`graph_103292-003-088`, `graph_Ca2737`, `graph_103292-003-031`, `graph_103292-003-074`, 
          `graph_103292-003-095`, `graph_Ca56-25`, `graph_18-572-2`, graph_CvS190028,
          nrow = 4, ncol = 2, labels = c("A", "B", "C", "D", "E", "F", "G", "H"), align = c("v"), common.legend = TRUE, legend = "bottom")
