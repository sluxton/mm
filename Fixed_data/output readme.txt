The file "all_plots_ppt_output.csv" has a record for each rain event which includes the micrometer parameters, the soil moisture parameters, and the Js response.

The file "all_data_ppt_pulse.csv" has the records removed for which there was no soil moisture or Js data. If there was even one piece of information there, the record was kept, but if there was nothing in those columns it was removed.

These files are usable, but perhaps not as usable as they could be. The reason for this is that when I was going through the VWC data to read it in, I realized that there are a lot of cases where 
1) a target tree may have a 5 cm sensor but not a profile, or vice versa
2) a target tree may have had both sets but died, so no Js data
3) replacement trees hardly ever have VWC sensors because they were mostly identified after the VWC sensors had been deployed

I need to get some more spatial information about the trees/sensors and then I think I may be able to fill some more data in. But this is a start.