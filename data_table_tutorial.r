

#install.packages("data.table")        # install it
library(data.table)                   # load it
example(data.table)                   # run some examples
?data.table                           # read
?fread                                # read
#update.packages()                     # keep up to date


# following along with this 
# https://rawgit.com/wiki/Rdatatable/data.table/vignettes/datatable-intro.html#data

## read and display data

flights <- fread("flights14.csv")
flights

dim(flights)


## Basics

DT = data.table(ID = c("b","b","b","a","a","c"), a = 1:6, b = 7:12, c = 13:18)
DT
class(DT$ID)

"""

DT[i, j, by]

##   R:      i                 j        by
## SQL:  where   select | update  group by

The way to read it (out loud) is:
Take DT, subset rows using i, then calculate j, grouped by by.
"""


