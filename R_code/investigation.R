
# read in
PPT <- read.table("./Fixed_data/ppt_pulse_output.txt", header = TRUE)
head(PPT)
str(PPT)

# as factor
PPT$fY <- factor(PPT$Year, levels = c("2007","2008","2009","2010","2011"))
PPT$ftrt <- factor(PPT$trt, levels = c("1","2","3","4"))
PPT$fbl <- factor(PPT$block, levels = c("3"))
PPT$fp.num <- factor(PPT$plot_num, levels = c("9","10","11","12"))

# manip
# index out the columns by name
Pd <- PPT[,c("fY", "ftrt", "fbl", "fp.num", "spp", "tree", "size", "dry_days", "pre_VPD", "Ys.min.15.avg", "Ys.min.20.avg", "Ys.min.d.avg", "Ys.max.15.avg", "Ys.max.20.avg", "Ys.max.d.avg", "vwc.min.avg", "vwc.max.avg", "Js.pre", "Js.D", "Js.d2")]

# this shows the non-unique treeid, right?
require(plyr)
require(ggplot2)
count(Pd, c("tree", "spp"))
count(Pd, c("ftrt", "dry_days"))
qplot(dry_days, data = Pd, geom = "freqpoly", binwidth = 5,  colour = ftrt) + xlim(c(0,80))

# plot by trees
c <- ggplot(Pd, aes(y = size, x = Js.D, colour = factor(tree))) 
c + stat_smooth(method = lm) + geom_point() 
c + stat_smooth(method = lm)

# severe overplotting. subset, just the first 10 trees
# NOTE: non-unique tree id, so this has one point for each 
Pd_one_ten <- subset(Pd, tree < 11)
d <- ggplot(Pd_one_ten, aes(y = size, x = Js.D)) + facet_wrap(~ tree, nrow = 2) 
d + stat_smooth(method = lm) + geom_point()

# include treatment info
e <- ggplot(Pd_one_ten, aes(y = size, x = Js.D, colour = ftrt)) + facet_wrap(~ tree, nrow = 2) 
e + stat_smooth(method = lm) + geom_point()
e + stat_smooth(method = lm)


# a single tree index, each treatments  
ind <- ceiling(runif(1)*10)
Pd_one <- subset(Pd, tree == ind)
f <- ggplot(Pd_one, aes(y = size, x = Js.D, colour = ftrt)) + facet_wrap(~ ftrt, nrow = 2)
f + stat_smooth(method = lm) + geom_point()

# year-by-treatment on a few tree indices
ind <- sample.int(n = 10, size  = 3, replace = F)
Pd_some <- subset(Pd, tree == ind[1] | tree == ind[2] | tree == ind[3])
g <- ggplot(Pd_some, aes(y = size, x = Js.D, colour = factor(tree))) #+ geom_point()
g + stat_smooth(method = lm, se = F, fullrange=T, size = 2) + facet_grid(ftrt ~ fY, scales = "free")

# same as above but with non-parametric curves fitted rather that linear regressions
ind <- sample.int(n = 10, size  = 3, replace = F)
Pd_some <- subset(Pd, tree == ind[1] | tree == ind[2] | tree == ind[3])
h <- ggplot(Pd_some, aes(y = size, x = Js.D, colour = factor(tree))) #+ geom_point()
h + stat_smooth(se = F, fullrange=T, size = 2) + facet_grid(ftrt ~ fY, scales = "free")

## weather trends????
Pd_single <- subset(Pd, tree == 1 & ftrt ==1)
h <- ggplot(Pd_single, aes(size)) + geom_histogram(binwidth = 5) 
h + facet_grid(. ~ fY)

hist(Pd_single$size, main = "Rain Event Distribution  (thresholded above 3mm)", xlab = "mm of rain")
summary(Pd_single$size)

# total rain (excluding small <3mm events)
Pd_single_minimal <- Pd_single[, c("fY", "size")]
qplot(fY, data = Pd_single_minimal, geom="bar", weight = size, ylab ="mm of rain", xlab = "") 
# quick check/ddply practice
tot <- ddply(Pd_single_minimal, .(fY), summarise, total_rain = sum(size))
# as a dotplot - doesn't really work
j <- ggplot(tot, aes(total_rain, fY))
j + geom_point() + ylab("") + xlab("mm of rain total")


k <- ggplot(tot, aes(total_rain, fY))
k + geom_area()
