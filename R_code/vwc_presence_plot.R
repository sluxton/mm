## read in
PA <- read.csv(file = "./Fixed_data/VWC_data_present.csv", header = T)

# binary matrix 
PA_bin <- PA[, -(1:11)]
PA_bin[PA_bin == "NaN"] <- 0 
colSums(PA_bin)

# start getting an idea of the sparsity
dotchart((colSums(PA_bin)/dim(PA_bin)[1]))
barplot(sort(colSums(PA_bin)/dim(PA_bin)[1]))

# sparse matrix visualization
#install.packages("SparseM")
require(SparseM)
SPA <- as.matrix.csr(as.matrix( t(PA_bin)[ncol(PA_bin):1,] ))
image(SPA, col = c("white", "grey60"), ylab = "Sensors", xlab = "Year", xaxt = "n")
legend(x = "left", c("absence","presence"), pch = c(19, 19), col = c("white", "grey60"))
axis(side = 1, at = seq(0, 1900, 365), labels = unique(PA$Year))

