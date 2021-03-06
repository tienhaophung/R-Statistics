require("Lock5withR")
require("APMultipleChoice")
library(mosaic)
library(mosaicData)

head(APMultipleChoice)

# Calculate p-value when we have x_squre = 3.1 and df = 2
pchisq(3.1, 2, lower.tail=FALSE)

# Test for Goodness of Fit
# Get table
t <- table(APMultipleChoice); t
f <- prop.table(t); f
# Chi-squre test
chisq.test(t)

# Test for Association.
attach(StudentSurvey)
chisq.test(table(Award, Gender))
# Randomization test
chisq.test(table(Award, Gender), simulate.p.value=TRUE)
detach(StudentSurvey)

# Chi-squre distribution
chisq.sample <- do(1000) * chisq.test(table(resample(toupper(letters[1:5]), 400)))$statistic
histogram(~X.squared, data = chisq.sample)

# Plot distribution of Chi-squre
plotDist("chisq", params = list(df = 4), type = c("h", "l"), groups = x > 3.425, lty = 1)
# Add lattice plots
ladd(grid.text("3.425", 3.425, 0.175, default.units = "native", hjust = 0))


jury <- c(780, 117, 114, 384, 58)
chisq.test(jury, p = c(0.54, 0.18, 0.12, 0.15, 0.01))
xchisq.test(jury, p = c(0.54, 0.18, 0.12, 0.15, 0.01)) # to list expected counts


# Import the data
file_path <- "http://www.sthda.com/sthda/RDoc/data/housetasks.txt"
housetasks <- read.delim(file_path, row.names = 1)
# head(housetasks)

library("gplots")
# 1. convert the data as a table
dt <- as.table(as.matrix(housetasks))
# 2. Graph
balloonplot(t(dt), main ="housetasks", xlab ="", ylab="",
            label = FALSE, show.margins = FALSE)

library("graphics")
mosaicplot(dt, shade = TRUE, las = 2, main = "housetasks")

table <- matrix(c(15, 5, 10, 20), nrow = 2, byrow = TRUE)
colnames(table) <- c("Nam", "Nu")
rownames(table) <- c("Kha", "Yeu")
tab <- as.table(table); tab

# Tong cong 25 nu va 25 nam. Trong do co 20 kha va 30 yeu

# Tinh expected value
expected <- as.array(margin.table(tab,1) %*% t(as.array(margin.table(tab,2)))) / margin.table(tab)
expected <- round(expected); expected

# Tinh chisq
chisq <- sum((tab - expected)^2 / expected); chisq
df1 <- 1
df2 <- 1
# Tinh p_value
p_value <- 1 - pchisq(chisq, df = df1*df2); p_value

# Chisq test
chisq.test(tab)

# Tinh TK can tim
stat <- function(data){
  Nam_Kha <- sum(data <= 25)
  Nam_Yeu <- margin.table(tab, 2)[1] - Nam_Kha
  Nu_Kha <- margin.table(tab, 1)[1] - Nam_Kha
  Nu_Yeu <- margin.table(tab, 2)[2] - Nu_Kha
  # convert to table
  tab2 <- matrix(c(Nam_Kha, Nam_Yeu, Nu_Kha, Nu_Yeu), nrow = 2, byrow = FALSE)
  tab2 <- as.table(tab2)
  
  return (sum(((tab2 - expected)^2) / expected))
}

randomization <??? function(B){
  # Xem nhu <= 25 la Nam, > 25 la Nu
  # Lay ngau nhien 20 kha
  return (replicate(B, stat(sample(1:50, 20))))
}

# Tinh chisq tren sample ban dau
chisq_sample <- chisq; chisq_sample
# Tim rand_dist
rand_dist <- randomization(10000)
# ve histogram
hist(rand_dist)
# Tim p_value
p_value <- sum(rand_dist >= chisq_sample) / length(rand_dist); p_value


pnorm(3, mean = 6.5, sd = 1.5)*50
