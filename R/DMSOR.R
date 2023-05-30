# activate packages
library(tidyverse)
library(mdthemes)
library(ggpubr)

# load in data
dmsor_results1 <- read.delim("D:/Data_analyse/Campylobacter_data/Raw_data/DMSOR/results+ve", sep = "\t")
dmsor_results2 <- read.delim("D:/Data_analyse/Campylobacter_data/Raw_data/DMSOR/results-ve", sep = "\t")

# added factors
dmsor_results1$electron_acceptor <- factor(dmsor_results1$electron_acceptor, levels = c("NO3", "DMSO", "NC"))
dmsor_results1$species <- factor(dmsor_results1$species, levels = c("CvS190009", "CvS190076", "103292-005-112", "Ca2196"))

dmsor_results2$electron_acceptor <- factor(dmsor_results2$electron_acceptor, levels = c("NO3", "DMSO", "NC"))
dmsor_results2$species <- factor(dmsor_results2$species, levels = c("18-451-1", "19-029-1", "103292-004-110", "Ca2425"))


# make both plots
graph1 <- dmsor_results1 %>%
  ggplot(aes(x = species, fill = electron_acceptor)) +
  geom_bar(position = position_dodge(), aes(y = colony_size), stat = "identity") +
  scale_y_continuous(breaks = 0:4, labels = c("No growth", "No colonies", "Tiny colonies", "Small colonies", "Average colonies")) +
  labs(title = "Colony size for DMSOR +ve *C. jejuni* and *C. coli*", 
       subtitle = "incubated with different electron acceptors",
       x = "Species",
       y = "Colony size",
       fill = "Used electron acceptor",
       caption = "CvS190009 is *C. coli*") +
  mdthemes::md_theme_classic()

graph2 <- dmsor_results2 %>%
  ggplot(aes(x = species, fill = electron_acceptor)) +
  geom_bar(position = position_dodge(), aes(y = colony_size), stat = "identity") +
  scale_y_continuous(breaks = 0:4, labels = c("No growth", "No colonies", "Tiny colonies", "Small colonies", "Average colonies")) +
  labs(title = "Colony size for DMSOR -ve *C. jejuni* and *C. coli*", 
       subtitle = "incubated with different electron acceptors",
       x = "Species",
       y = "Colony size",
       fill = "Used electron acceptor",
       caption = "18-451-1 is *C. coli*") +
  mdthemes::md_theme_classic()

# turn it into one plot and save it
final_plot <- ggarrange(graph1, graph2, nrow = 2, labels = c("A", "B"), legend = "bottom", common.legend = TRUE)

ggsave("DMSOR.png", plot = final_plot, width = 600, height = 800, path = "results/DMSOR", units = "px", dpi = 96, )
