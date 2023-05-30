library(tidyverse)
library(mdthemes)
library(ggpubr)

# T6SS -ve E. coli plot makig
no_hunting <- read.delim("D:/Data_analyse/Campylobacter_data/Raw_data/T6SS/no_hunting", sep = "\t")
no_hunting$species <- as.factor(no_hunting$species)
no_hunting$species <- factor(no_hunting$species,
                             levels = c("17S00394-1 | E. coli", "103292-003-088 | T6SS -ve", 
                                        "18S01641-1 | T6SS +ve", "18S01741-1 | T6SS +ve"))


plot_no_hunting <- no_hunting %>%
  group_by(time, as.factor(species)) %>%
  ggplot(aes(x = time, y = CFU)) +
  geom_line(aes(colour = species), linewidth = .8) +
  geom_point(aes(colour = species)) +
  scale_y_log10() +
  labs(title = "CFU of a T6SS -ve *E. coli* co-cultured with T6SS +ve and T6SS -ve *C. jejuni*",
       x = "Time in hours after *E. coli* was added",
       y = "CFU/ml *E. coli*") +
  scale_colour_discrete(name = "Species") +
  mdthemes::md_theme_classic()


ggsave("T6SS_no_hunting.png", plot = ggarrange(plot_no_hunting, legend = "bottom"), width = 1000, height = 600,
       path = "results/T6SS", units = "px", dpi = 96)

# T6SS +ve E.coli plot for E. coli
hunting_e_coli <- read.delim("D:/Data_analyse/Campylobacter_data/Raw_data/T6SS/hunting_e_coli", sep = "\t")
hunting_e_coli$species <- as.factor(hunting_e_coli$species)
hunting_e_coli$species <- factor(hunting_e_coli$species,
                             levels = c("18S03495-1 | E. coli", "103292-003-088 | T6SS -ve", 
                                        "18S01641-1 | T6SS +ve", "103292-005-112 | T6SS +ve"))


plot_hunting_e_coli <- hunting_e_coli %>%
  group_by(time, as.factor(species)) %>%
  ggplot(aes(x = time, y = CFU)) +
  geom_line(aes(colour = species), linewidth = .8) +
  geom_point(aes(colour = species)) +
  scale_y_log10() +
  labs(title = "CFU of a T6SS +ve *C. jejuni* co-cultured with T6SS +ve and T6SS -ve *C. jejuni*",
       x = "Time in hours after *E. coli* was added",
       y = "CFU/ml *E. coli*") +
  scale_colour_discrete(name = "Species") +
  mdthemes::md_theme_classic()

ggarrange(plot_hunting_e_coli, legend = "bottom")
ggsave("T6SS_hunting_e.coli.png", plot = ggarrange(plot_hunting_e_coli, legend = "bottom"), width = 1000, height = 600,
       path = "results/T6SS", units = "px", dpi = 96)



# T6SS +ve E.coli plot for both C.jejuni +ve and -ve
hunting_c_jejuni1 <- read.delim("D:/Data_analyse/Campylobacter_data/Raw_data/T6SS/hunting_c_jejuni+", sep = "\t")
hunting_c_jejuni1$species <- as.factor(hunting_c_jejuni1$species)
hunting_c_jejuni1$species <- factor(hunting_c_jejuni1$species,
                                 levels = c("18S01641-1 | T6SS +ve", "18S01641-1 | Control"))


hunting_c_jejuni2 <- read.delim("D:/Data_analyse/Campylobacter_data/Raw_data/T6SS/hunting_c_jejuni-", sep = "\t")
hunting_c_jejuni2$species <- as.factor(hunting_c_jejuni2$species)
hunting_c_jejuni2$species <- factor(hunting_c_jejuni2$species,
                                    levels = c( "103292-003-088 | T6SS -ve", "103292-003-088 | Control"))


plot_hunting_c_jejuni1 <- hunting_c_jejuni1 %>%
  group_by(time, as.factor(species)) %>%
  ggplot(aes(x = time, y = CFU)) +
  geom_line(aes(colour = species), linewidth = .8) +
  geom_point(aes(colour = species)) +
  geom_errorbar(aes(ymin = CFU - st_dev, ymax = CFU + st_dev, colour = species),
                width = .2) +
  scale_y_log10() +
  labs(title = "CFU of a T6SS +ve *C. jejuni* co-cultured with T6SS +ve *E. coli*",
       x = "Time in hours after *E. coli* was added",
       y = "CFU/ml *C. jejuni*") +
  scale_colour_discrete(name = "Species") +
  mdthemes::md_theme_classic()

plot_hunting_c_jejuni2 <- hunting_c_jejuni2 %>%
  group_by(time, as.factor(species)) %>%
  ggplot(aes(x = time, y = CFU)) +
  geom_line(aes(colour = species), linewidth = .8) +
  geom_point(aes(colour = species)) +
  scale_y_log10() +
  geom_errorbar(aes(ymin = CFU - st_dev, ymax = CFU + st_dev, colour = species),
                width = .2) +
  labs(title = "CFU of a T6SS -ve *C. jejuni* co-cultured with T6SS +ve *E. coli*",
       x = "Time in hours after *E. coli* was added",
       y = "CFU/ml *C. jejuni*") +
  scale_colour_discrete(name = "Species") +
  mdthemes::md_theme_classic()

final_plot <- ggarrange(plot_hunting_c_jejuni1, plot_hunting_c_jejuni2, nrow = 2, labels = c("A", "B"), legend = "bottom")

ggsave("T6SS_c.jejuni_hunting.png", plot = final_plot, width = 600, height = 600, path = "results/T6SS", units = "px", dpi = 96, )


