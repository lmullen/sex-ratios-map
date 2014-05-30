options(stringsAsFactors = FALSE)
library(dplyr)
library(ggplot2)
library(stringr)
library(mullenMisc)

data_state <- read.csv("data/nhgis0018_csv/nhgis0018_ts_state.csv")
data_county <- read.csv("data/nhgis0018_csv/nhgis0018_ts_county.csv")

data_state <- data_state %.%
  mutate(diff = (A08AB / (A08AA + A08AB)) * 100 - 50) %.%
  mutate(state = str_replace(STATE, " Territory", "")) %.%
  filter(STATE != "Puerto Rico") %.%
  filter(STATE != "Persons in the Military") %.%
  filter(STATE != "Indian Territory") %.%
  mutate(total = A08AA + A08AB)

data_county <- data_county %.%
  mutate(diff = (A08AB / (A08AA + A08AB)) * 100 - 50) %.%
  mutate(total = A08AA + A08AB) %.%
  mutate(diff_abs = A08AB - A08AA)

# Distribution of sex differences by geographic area
ggplot(data_state, aes(x = diff)) + geom_histogram(binwidth = 1)
ggplot(data_county, aes(x = diff)) + geom_histogram(binwidth = 1)

plot_state <- ggplot(data_state, aes(x = YEAR, y = diff, group = state)) +
  geom_line(color = "red", alpha = 0.25) +
  geom_hline(yintercept = 0) +
#    facet_wrap(~ state, ncol=6)
  ggtitle("Deviation of Sex Ratio of Population in U.S. States and Territories, 1820-2010") + xlab(NULL) +
  ylab("Percentage above/below equal sex ratio") +
  annotate("text", x = 1960, y = -15, label = "More male") +
  annotate("text", x = 1960, y = 5, label = "More female")

plot_county <- ggplot(data_county,
                      aes(x = YEAR, y = diff, group = GISJOIN)) +
  geom_line(color = "red", alpha = 0.125) +
  geom_hline(yintercept = 0) +
  ggtitle("Deviation of Sex Ratio of Population in U.S. Counties, 1820-2010") + xlab(NULL) +
  ylab("Percentage above/below equal sex ratio") +
  annotate("text", x = 1960, y = -15, label = "More male") +
  annotate("text", x = 1960, y = 15, label = "More female")

plot_county_abs <- ggplot(data_county,
                      aes(x = YEAR, y = diff_abs, group = GISJOIN)) +
  geom_line(color = "red", alpha = 0.125) +
  geom_hline(yintercept = 0) +
  ggtitle("Deviation of Sex Ratio of Population in U.S. Counties, 1820-2010") + xlab(NULL) +
  ylab("Number of females more than males") +
  annotate("text", x = 1960, y = -15, label = "More male") +
  annotate("text", x = 1960, y = 15, label = "More female") +
  coord_trans(y = "log10")

print(gg_attribution(plot_state, "Data: NHGIS; Plot: Lincoln Mullen"))
print(gg_attribution(plot_county, "Data: NHGIS; Plot: Lincoln Mullen"))
print(gg_attribution(plot_county_abs, "Data: NHGIS; Plot: Lincoln Mullen"))
