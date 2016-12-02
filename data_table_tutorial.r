

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



# DT[i, j, by]

##   R:      i                 j        by
## SQL:  where   select | update  group by

# The way to read it (out loud) is:
# Take DT, subset rows using i, then calculate j, grouped by by.


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

# Great! But how can I refer to columns by names in j (like in a data.frame)?
#You can refer to column names the data.frame way using with = FALSE.

# Select both arr_delay and dep_delay columns the data.frame way.
ans <- flights[,c("arr_delay", "dep_delay"), with = FALSE]
head(ans)

# aggregations
# a) Grouping using by
# How can we get the number of trips corresponding to each origin airport?
ans <- flights[, .(.N), by= .(origin)]
ans

# – How can we calculate the number of trips for each origin airport for carrier code “AA”?
ans <- flights[carrier == 'AA', .(.N), by= .(origin)]
ans

# How can we get the total number of trips for each origin, dest pair for carrier code “AA”?
ans <- flights[carrier == 'AA', .(.N), by = .(origin,dest)]
head(ans)

# How can we get the average arrival and departure delay for each orig,dest pair 
# for each month for carrier code “AA”?
ans <- flights[carrier == 'AA', .(mean(arr_delay),mean(dep_delay)), .(origin,dest,month) ]
ans

# b) keyby
# data.table retaining the original order of groups is intentional and by design. 
# There are cases when preserving the original order is essential. But at times 
# we would like to automatically sort by the variables we grouped by.

# So how can we directly order by all the grouping variables?

ans <- flights[carrier == 'AA', .(mean(arr_delay),mean(dep_delay)), 
               keyby = .(origin,dest,month) ] # change by to keyby to order
ans

# c) Chaining
# Let’s reconsider the task of getting the total number of trips for each origin, 
# dest pair for carrier “AA”.

ans <- flights[carrier == 'AA', .N, .(origin,dest)]
ans

# – How can we order ans using the columns origin in ascending order, and dest 
# in descending order?

# We can store the intermediate result in a variable, and then use order(origin, -dest) 
# on that variable. It seems fairly straightforward.

ans <- ans[order(origin, -dest)]
head(ans)

# But this requires having to assign the intermediate result and then overwriting 
# that result. We can do one better and avoid this intermediate assignment on to 
# a variable altogether by chaining expressions.

ans <- flights[carrier== 'AA', .N, .(origin, dest)][order(origin, -dest)]
head(ans)

# d) Expressions in by
## Can by accept expressions as well or just take columns?
### Yes it does. As an example, if we would like to find out how many flights 
### started late but arrived early (or on time), started and arrived late etc…

ans <- flights[, .N, .(dep_delay > 0, arr_delay > 0)]
ans

# e) Multiple columns in j - .SD
# Do we have to compute mean() for each column individually?

ans <- DT[, lapply(.SD, mean), by= ID]
ans

# How can we specify just the columns we would like to compute the mean() on?

ans<- flights[carrier == "AA",                       ## Only on trips with carrier "AA"
        lapply(.SD, mean),                     ## compute the mean
        by = .(origin, dest, month),           ## for every 'origin,dest,month'
        .SDcols = c("arr_delay", "dep_delay")] ## for just those specified in .SDcols
ans

# f) Subset .SD for each group:
# How can we return the first two rows for each month?

ans <- flights[, head(.SD, 2), by = month]
head(ans)

# How can we concatenate columns a and b for each group in ID?

DT[, .(val = c(a,b)), by = ID]

# What if we would like to have all the values of column a and b concatenated, 
# but returned as a list column?

DT[, .(val = list(c(a,b))), by = ID]
