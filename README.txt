5-6-2012

Since I've just been toying around with R, I've just named my scripts with the date, so the 5-3-2012 file is the most recent one.

There's a text file to remind me how this computer god in my lab got the AED package installed on my Mac. That package, by the way, is at www.highstat.com, and you click on the image of the book (with the penguins jumping into ice cold water). 

The file "ppt_pulse_output.txt" has the independent and response variables. 
I list the column headers below, but note that the R script doesn't use all of them. 

Column headers are:
Year - 2007-2011
PJDay_start - the starting PJDay of the precip event
PJDay_end - ending day, i.e. the day before the start of the next one
JDay_start - Julian starting day
size - in mm
dry_days - # of rainless days before the event
trt - treatment (1=water addition, 2=drought, 3=cover conrol, 4=ambient)
block - 1=flat, 2=north-facing, 3= SE-facing
plot_num - plot numbers (1-4 are flat, 5-8 are N-facing, 9-12 are SE-facing. This .txt file only has the 9-12 data, where 9=water addition, 2=drought, 3=cover control, 4=ambient)
tree - target tree #. Originally, pinon were 1-5, juniper 6-10, but when trees started dying and being replaced, we also established that #11-15 was any replacement  pinon and 16-20 any replacement juniper.
pre_PAR - Photosynthetically active radiation (sunlight) before the event
pre_T - temperature before the event
pre_VPD - vapor pressure deficit before the event
Ys-min-15 - Psi-soil at 15 cm depth, minimum preceding event - this variable and the eight folioing are each "per tree", i.e. it refers to the sensor under each target tree. So there are a ton of missing data.
Ys-min-20 - same, 20 cm
Ys-min-d - same, "deep" sensor
Ys-max-15 - maximum Psi-soil between PJDay_start and PJDay_end
Ys-max-20 - same, 20 cm
Ys-max-d - same, "deep" sensor
Ys-15-D - D stands for Delta, difference between after and before event
Ys-20-D
Ys-d-D
Ys-min-15-avg - same as Ys-min-15 above, but this is the average of all the sensors at that depth on each plot, so there are fewer missing values (but the values are arguably less accurate).
Ys-min-20-avg
Ys-min-d-avg
Ys-max-15-avg
Ys-max-20-avg
Ys-max-d-avg
Ys-15-D-avg - this is the average change in Ysoil, so taking all the sensors that have both a "before" and an "after" value, calculating the differences, and averaging the differences.
Ys-20-D-avg
Ys-d-D-avg
vwc-min - minimum volumetric water content before the pulse
vwc-max - maximum volumetric water content after the pulse
vwc-D - Delta
vwc-min-avg - plot-average pre-pulse minimum
vwc-max-avg - plot-average post-pulse maximum
vwc-D-avg - average Delta
Js.pre - tree sapflow before the pulse
Js-post - maximum sapflow in the 7 days following the event
Js-D - Js.post - Js.pre (note that in a huge # of cases, this is a negative number, which is annoying. I think.)
Js-d2 - Js on day 2 of the event, just to provide a reference.


