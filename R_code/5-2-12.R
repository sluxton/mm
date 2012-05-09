> getwd()
[1] "/Users/jenniferplaut/Dropbox/pj/data/R code"
> P <- read.table("ppt_pulse_output.txt", header = TRUE)
> head(P)
> PPT <- cbind(P$size, P$dry_days, P$trt, P$Ys.min.15, P$Ys.min.15.avg, P$Ys.max.15, P$Ys.max.15.avg, P$vwc_min, P$vwc_max, P$vwc.max.avg, P$Js.D, P$Js.d2)
> colnames(PPT) <- c("size","dry.days","trt","Ymin","Ymin.avg","Ymax","Ymax.avg","vwc.min","vwc.max","vwc.max.avg","Js.D","Js.d2")
> pairs(PPT, lower.panel = panel.smooth2, upper.panel = panel.cor, diag.panel = panel.hist)

dim(PPT)

# These don't work (atomic vector error)
PPT$ftrt <- factor(PPT$trt)
PPT$fspp <- factor(PPT$spp)
dotchart(PPT$vwc.min, main = "vwcmin", group = PPT$ftrt)
dotchart(PPT$vwc.min, main = "vwcmin", group = PPT$fspp)

as.data.frame(PPT)
dim(PPT)
f <- factor(P$trt)