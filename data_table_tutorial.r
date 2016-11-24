

#install.packages("data.table")        # install it
library(data.table)                   # load it
example(data.table)                   # run some examples
?data.table                           # read
?fread                                # read
#update.packages()                     # keep up to date

## read and display data

flights <- fread("flights14.csv")
flights

dim(flights)
