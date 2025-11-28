library(tidyverse)

# Load data (AED output)
aed <- read_tsv("assembly.all.maker.renamed.gff.AED.txt", skip=1, col_names = c("AED", "Cumulative"))

# Cumulative proportion at AED = 0.5
y_at_05 <- aed %>% filter(AED == 0.500) %>% pull(Cumulative)

# Plot cumulative AED distribution
ggplot(aed, aes(x = AED, y = Cumulative)) +
  geom_line(size = 1.2, color = "grey34") +
  geom_point(size = 2, color = "black") +
  scale_x_continuous(limits = c(0,1)) +
  scale_y_continuous(limits = c(0,1)) +
  labs(
    title = "Cumulative AED Distribution",
    x = "Annotation Edit Distance (AED)",
    y = "Cumulative proportion of annotations"
  ) +
  theme_minimal(base_size = 14) +
  geom_vline(xintercept = 0.5, linetype = "dotted", color = "red3", size=0.7) +
  geom_hline(yintercept = y_at_05, linetype = "dotted", color = "red3", size=0.7) +
  annotate("text",
           x = 0.52, y = y_at_05,
           label = paste0("AED 0.5: ", round(y_at_05*100,1), "% supported"),
           hjust = 0, vjust = 2, color = "red3", size = 4)

# Save
ggsave("Plots/AED_cumulative_distribution.pdf", width = 8, height = 5)

dev.off()