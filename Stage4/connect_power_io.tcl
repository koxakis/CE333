globalNetConnect vdd! -type pgpin -pin vdd! -inst * -verbose
globalNetConnect vss! -type pgpin -pin vss! -inst * -verbose
globalNetConnect vdd! -autoTie -inst vdd_* -pin pad -verbose
globalNetConnect vss! -autoTie -inst vss_* -pin pad -verbose
globalNetConnect vdd! -type tiehi -verbose
globalNetConnect vss! -type tielo -verbose