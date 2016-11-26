

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

# Get all the flights with “JFK” as the origin airport in the month of June.

ans <- flights[origin == "JFK" & month == 6L]
head(ans)

# get the first two rows from flights
ans <- flights[1:2]
ans

# Sort flights first by column origin in ascending order, and then by dest in descending order:

ans <- flights[order(origin, -dest)]
head(ans)

# Select arr_delay column, but return it as a vector
ans <- flights[,arr_delay]
head(ans)

# .() will be used instead of list() going forward

# Select both arr_delay and dep_delay columns.
ans <- flights[,.(arr_delay, dep_delay)]
head(ans)

# Select both arr_delay and dep_delay columns and rename them to delay_arr and delay_dep
ans <- flights[,.('delay_arr'= arr_delay, 'delay_dep' = dep_delay)]
head(ans)

# e) Compute or do in j

# How many trips have had total delay < 0?
ans <- flights[, sum((arr_delay + dep_delay) <0 )]
ans


# Subset in i and do in j

# Calculate the average arrival and departure delay for all flights with “JFK” as 
# the origin airport in the month of June.

ans <- flights[origin == 'JFK' & month == 6L, 
               .('m_arr'= mean(arr_delay), 'm_dep' = mean(dep_delay))]
ans

colnames(flights)

# How many trips have been made in 2014 from “JFK” airport in the month of June?
ans <- flights[origin == 'JFK' & month == 6L, length(dest)]
ans

# we could have picked any column since we just returned the number of rows
# or length of the subset

# now lets use the special operator .N. .N holds the number of observations in
# the current group

ans <- flights[origin == 'JFK' & month == 6L, .N]
ans
