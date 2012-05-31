VWC_data_present.csv
Columns 1-11 are "index" columns with time/date information

For each plot there are 36 columns:
1-11 are the "depth 1" = 5 cm
12-36 are depths 2-4 = 15, 20, and "deep"

Column headers have all that information
Digit #1 = Block (1 = flat, 2 = N-facing, 3 = SE-facing)
Digit #2 = plot (1+5+9 = water addition, 2+6+10 = drought, 3+7+11 = cover control, 4+8+12 = ambient control)
Digit #3 = location (1-3 = pinon cover, 4-6 = juniper cover, 7-9 = intercanopy)
*** Block 3 has n=5 sensors per cover type, so there is an extra digit on those column headers. 1-5 = pinion, 6-10 = juniper, 11-15 = intercanopy***
Digit #4 = depth (1 = 5cm, 2 = 15cm, 3 = 20cm, 4 = ~60 cm)

So Block 1, treatment 1, tree 6 (a juniper), depth 1 would be "1141" but
Block 3, treatment 1, tree 6, depth 1 would be "31061". If you have an idea   of how to make that more cogent, let me know! I didn't think it was important enough to put too much time into.

Data are entered as "NaN" if not present or "1" if data are present

*** It's really interesting to see how, on Block 3, the data from the soil psychrometers (which has been converted to VWC) disappears when it gets really dry, as in the period before PJDay 2000. That was the height of last summer's drought, and while the sensors on Plot 9 (water addition) managed to hang in there, the majority of the sensors on the other plots got too dry and stopped giving usable output.

In the file "VWC_data_present_incrementing.csv" everything is set up exactly the same except that the entries for "data present" increment with column #. So you can plot them vs column 9 (PJ Day) and they stack rather than plotting on top of each other. That was my crude work-around to make the plot in Matlab; R probably has its own elegant solution that will work with the first data table, but I wasn't sure so I put both of them here.
