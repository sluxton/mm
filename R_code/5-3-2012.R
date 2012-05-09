# data exploration on ppt pulse data
library(AED)
PPT <- read.table("ppt_pulse_output.txt", header = TRUE)
# head(PPT)
PPT$fY <- factor(PPT$Year, levels = c("2007","2008","2009","2010","2011"))
PPT$ftrt <- factor(PPT$trt, levels = c("1","2","3","4"))
PPT$fbl <- factor(PPT$block, levels = c("3"))
PPT$fp.num <- factor(PPT$plot_num, levels = c("9","10","11","12"))

# generating P using cbind makes all the vectors atomic; using data.frame preserves the vector classes
P <- data.frame(PPT$fY, PPT$ftrt, PPT$fbl, PPT$fp.num, PPT$spp, PPT$tree, PPT$size, PPT$dry_days, PPT$pre_VPD, PPT$Ys.min.15.avg, PPT$Ys.min.20.avg, PPT$Ys.min.d.avg, PPT$Ys.max.15.avg, PPT$Ys.max.20.avg, PPT$Ys.max.d.avg, PPT$vwc.min.avg, PPT$vwc.max.avg, PPT$Js.pre, PPT$Js.D, PPT$Js.d2)

colnames(P) <- c("fY","ftrt","fblock","fp.num","spp","tree.num","size","dry.days","VPD.pre","Ymin.15", "Ymin.20","Ymin.d", "Ymax.15", "Ymax.20", "Ymax.d", "vwc.min","vwc.max","Js.pre", "Js.D","Js.d2")
# calculate response as a ratio
P$Js.r <- P$Js.D/P$Js.pre

# remove data for events within 2 days of another event - but what if the first is tiny and the second is huge?
# P <- P[P$dry.days>2 & P$Ymin.15< -1,]
P <- subset(P, subset=(Ymin.15 < -1 & dry.days > 2))

# make Cleveland dotplots
op <- par(mfrow = c(7,2), mar = c(3,3,3,1))
dotchart(P$Js.D, main = "Js.D", group = P$ftrt)
dotchart(P$Js.d2, main = "Js.d2", group = P$ftrt)
dotchart(P$Js.r, main = "Js.r", group = P$ftrt)
dotchart(P$Ymin.15, main = "Ymin.15", group = P$ftrt)
dotchart(P$Ymin.20, main = "Ymin.20", group = P$trt)
dotchart(P$Ymin.d, main = "Ymin.d", group = P$ftrt)
dotchart(P$Ymax.15, main = "Ymax.15", group = P$ftrt)
dotchart(P$Ymax.20, main = "Ymax.20", group = P$ftrt)
dotchart(P$Ymax.d, main = "Ymax.d", group = P$ftrt)
dotchart(P$vwc.min, main = "vwc.min", group = P$ftrt)
dotchart(P$vwc.max, main = "vwc.max", group = P$ftrt)
dotchart(P$Js.pre, main = "Js.pre", group = P$ftrt)
dotchart(P$size, main = "size", group = P$ftrt)
dotchart(P$dry.days, main = "dry.days", group = P$ftrt)
par(op)

# make pairplots
pairs(P, lower.panel = panel.smooth2, upper.panel = panel.cor, diag.panel = panel.hist)

# calculate variance inflation factors (VIF) - results indicate lots of collinearity! (values > 3)
corvif(P[, c(7:18)])

M1 <- lm(Js.D ~ Ymin.15 + Ymin.20 + Ymin.d + Ymax.15 + Ymax.20 + Ymax.d + vwc.min + vwc.max + size + dry.days + Js.pre + ftrt + fY + spp, data = P)

# summary shows that lots of variables appear to be significant; no 2007 data are included because of no Ysoil data, resulting in a lot of observatoins being deleted.
# interestingly, when the events with dry.days<2 and Ymin.15 > -1 MPa are removed, the effect of year disappears, i.e. year is no longer significant. According to "summary", trt2 is sig diff from trt1
summary(M1)

# When the dataset is reduced, according to this test, trt is not significant! Nor is year.
drop1(M1, test="F")
# the anova says that trt is significant, but year is not (for the reduced dataset)
anova(M1)

# the step() function does backwards selection based on Akaike information criteria (AIC). According to that, all the variables being tested are significant except for dry.days and Ymin.d. When the dataset is reduced, it throws out trt and Ymax.20, .
step(M1)

# re-model based on the AIC results:
M2 <-lm(formula = Js.D ~ Ymin.15 + Ymin.20 + Ymax.15 + Ymax.20 + Ymax.d + vwc.min + vwc.max + size + Js.pre + ftrt + fY + spp, data = P)
# or:
M2 <-lm(formula = Js.D ~ Ymin.15 + Ymin.20 + Ymin.d + Ymax.15  + Ymax.d + vwc.min + vwc.max + size + dry.days + Js.pre + spp, data = P)
# the summary says that not all levels of "ftrt" or "fY" are significant, but we include the variables anyways. For the reduced dataset, everything is significant
summary(M2)
# the anova says that now Ymin.20 and vwc.min are not significant. Not sure who to believe here. On reduced dataset, Ymin.20 is also non-significant
anova(M2)

# Next: Model validation , p.543 (make some graphs)
M3 <- lm(formula = Js.D ~ Ymin.15 + Ymin.20 + Ymin.d + Ymax.15  + Ymax.d + vwc.min + vwc.max + size + dry.days + Js.pre + spp, data = P)
op <- par(mfrow = c(2,2))
plot(M3)
# win.graph(); # this returns an error, I don't know what package this function is in
op <- par(mfrow = c(2,2))
E <- rstandard(M3)
hist(E)
qqnorm(E)
plot(y = E, x = P$Ymax.15, xlab = "Ymax.15", ylab = "Residuals")
abline(0,0)
plot(y = E, x = P$Js.pre, xlab = "Js.pre", ylab = "Residuals")
abline(0,0)


# Additive modeling
library(mgcv)
AM1 <- gam(Js.D ~ Ymin.15 + Ymin.20 + Ymin.d + Ymax.15 + Ymax.20 + Ymax.d + vwc.min + vwc.max + size + dry.days + Js.pre + ftrt + fY + spp, data = P)
anova(AM1)

AM2 <- gam(Js.r ~ s(Ymin.15, bs = "cs") + s(Ymin.20, bs = "cs") + s(Ymin.d, bs = "cs") + s(Ymax.15, bs = "cs") + s(Ymax.20, bs = "cs") + s(Ymax.d, bs = "cs") + s(vwc.min, bs = "cs") + s(vwc.max, bs = "cs") + s(size, bs = "cs") + s(dry.days, bs = "cs") + s(Js.pre, bs = "cs") + ftrt + fY + spp, data = P)

# probably should have done this earlier, but since spp is significant, I'm splitting the dataset in two by spp.
P.P <- P[P$spp=="P",]
P.J <- P[P$spp=="J",]
AM3 <- gam(Js.D ~ s(Ymin.15, bs = "cs") + s(Ymin.20, bs = "cs") + s(Ymin.d, bs = "cs") + s(Ymax.15, bs = "cs") + s(Ymax.20, bs = "cs") + s(Ymax.d, bs = "cs") + s(vwc.min, bs = "cs") + s(vwc.max, bs = "cs") + s(size, bs = "cs") + s(dry.days, bs = "cs") + s(Js.pre, bs = "cs") + ftrt + fY, data = P.P)
# now for PIED, Ymax.d and Js.pre drop out (no DF?) but everything else is signficant
anova(AM3)
AM4 <- gam(Js.D ~ s(Ymin.15, bs = "cs") + s(Ymin.20, bs = "cs") + s(Ymin.d, bs = "cs") + s(Ymax.15, bs = "cs") + s(Ymax.20, bs = "cs") + s(Ymax.d, bs = "cs") + s(vwc.min, bs = "cs") + s(vwc.max, bs = "cs") + s(size, bs = "cs") + s(dry.days, bs = "cs") + s(Js.pre, bs = "cs") + ftrt + fY, data = P.J)
# and for JUMO, everything is significant except Year(!), Ymin.15, and Ymax.d
anova(AM4)
AM5 <- gam(Js.D ~ s(Ymin.20, bs = "cs") + s(Ymin.d, bs = "cs") + s(Ymax.15, bs = "cs") + s(Ymax.20, bs = "cs") + s(vwc.min, bs = "cs") + s(vwc.max, bs = "cs") + s(size, bs = "cs") + s(dry.days, bs = "cs") + s(Js.pre, bs = "cs") + ftrt, data = P.J)
# remove those terms and everything else is still significant
anova(AM5)

# plot residuals for GAMs
E.AM3<- resid(AM3)
Fit.AM3 <- fitted(AM3)
# there isn't really a "pattern", but the fitted values cluster to the left. No trend I'd say, though.
plot(x = Fit.AM3, y = E.AM3, xlab = "Fitted values", ylab = "Residuals")

E.AM5<- resid(AM5)
Fit.AM5 <- fitted(AM5)
# JUMO is much more of a shotgun blast centered on about x=2
plot(x = Fit.AM5, y = E.AM5, xlab = "Fitted values", ylab = "Residuals")