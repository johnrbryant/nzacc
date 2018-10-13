
library(methods)
library(tibble)

## Values copied from Statistics New Zealand. 2006.
## A Report on the 2006 Post-enumeration Survey. Table 1

net_undercount <- tribble(
    ~variable, ~time, ~age,    ~value,
    "000",     2001,  "0-14",  23,
    "000",     2001,  "15-29", 24,
    "000",     2001,  "30-44", 20,
    "000",     2001,  "45+",   18,
    "percent", 2001,  "0-14",  2.7,
    "percent", 2001,  "15-29", 3.1,
    "percent", 2001,  "30-44", 2.3,
    "percent", 2001,  "45+",   1.4,
    "error",   2001,  "0-14",  0.5,
    "error",   2001,  "15-29", 0.6,
    "error",   2001,  "30-44", 0.5,
    "error",   2001,  "45+",   0.3,
    "000",     2006,  "0-14",  14,
    "000",     2006,  "15-29", 35,
    "000",     2006,  "30-44", 11,
    "000",     2006,  "45+",   21,
    "percent", 2006,  "0-14",  1.6,
    "percent", 2006,  "15-29", 4.1,
    "percent", 2006,  "30-44", 1.3,
    "percent", 2006,  "45+",   1.4,
    "error",   2006,  "0-14",  0.5,
    "error",   2006,  "15-29", 1.6,
    "error",   2006,  "30-44", 0.6,
    "error",   2006,  "45+",   0.5
)


saveRDS(net_undercount,
        file = "data/net_undercount.rds")
