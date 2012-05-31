
# read in
DD <- read.csv(file = "./Fixed_data/all_data_ppt_output.csv", header = T)
DD <- data.frame(DD, DD$Js_post - DD$Js_pre)
names(DD)[24] <- "Js_diff"
require(plyr)
count(DD, c("Year","tree_ID"))

# lots of non-informative
CC <- subset(DD, Js_diff != "NaN")
#CC <- subset(CC, tree_ID < 21)
#CC <- cbind(rep(1, dim(CC)[1]), CC)

# visualize - mostly from Hadley's webpage
a <- qplot(tree_ID, Js_diff, data = CC) 
a + stat_summary(fun.data = "mean_cl_boot", colour = "red", size = 1.1) + facet_grid(. ~ Year)

b <- ggplot(CC, aes(y = Js_diff, x = event_size, colour = factor(Year))) + geom_point()
b + stat_smooth(method = lm, se = F, fullrange=T, size = 2) + facet_wrap( ~ tree_ID, scales = "free")

#install.packages("lme4")
#install.packages("arm")
require(lme4)
require(arm)

## standard linear regression
SLR <- lm(Js_diff ~ -1 + event_size + factor(Year), data = CC)
display(SLR)

## varying intercept, no predictors
VINP <- lmer(Js_diff ~ 1 + (1 | treatment), data = CC, REML = T, verbose = T)
display(VINP)

## varying intercept (by treatment), one predictor
# this ignores the fact that event_size is really a predictor at the treatment-level
# i'm not sure how much of a concern that really is
VIOP <- lmer(Js_diff ~ event_size + (1 | treatment), data = CC, REML = T, verbose = T)
display(VIOP)
coef(VIOP)

## varying intercept and varying slope (by treatment), one predictor
# again ignoring the same
VIVP <- lmer(Js_diff ~ event_size + (1 + event_size | treatment), data = CC, REML = T, verbose = T)
display(VIVP)
coef(VIVP)

## Same as above, but with year as the grouping variable
## varying intercept (by year), one predictor
# again ignoring the same
VIOPy <- lmer(Js_diff ~ event_size + (1 | Year), data = CC, REML = T, verbose = T)
display(VIOPy)
coef(VIOPy)

## varying intercept and varying slope (by year), one predictor
# again ignoring the same
VIVPy <- lmer(Js_diff ~ event_size + (1 + event_size | Year), data = CC, REML = T, verbose = T)
display(VIVPy)
coef(VIVPy)




