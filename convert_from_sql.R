library('DBI')
library('RSQLite')
library('data.table')

setwd('C:/Users/rmcgibony/Documents/Graph Databases Talk')

# This connection creates an empty database if it does not exist
db <- dbConnect(SQLite(), dbname = "./northwind.db")

dbListTables(db)

dbGetQuery(db, "SELECT * FROM Orders LIMIT 5")


dbGetQuery(db, "
SELECT orderid, sum(unitprice * quantity) as total FROM 'Order Details'
GROUP BY orderid
ORDER BY TOTAL DESC
LIMIT 10;
")



# Orders
orders <- dbGetQuery(db, "
SELECT o.orderid, o.shippeddate, o.customerid, o.shipname, o.shipaddress, t.total, o.employeeid
FROM Orders o
JOIN 
  (SELECT orderid, sum(unitprice * quantity) as total FROM 'Order Details'
  GROUP BY orderid) t
  ON o.orderid = t.orderid
           ")
orders$ShippedDate <- substr(orders$ShippedDate, 1, 10)
write.csv(orders, './tmp/orders.csv')

# Customers
customers <- dbGetQuery(db, "
SELECT customerid, companyname, contactname, address, phone
FROM Customers
                      ")
# Remove bad records
customers <- customers[!customers$CustomerID %in% c("Val2 ","VALON"), ]

write.csv(customers, './tmp/customers.csv')

# Employees
employees <- dbGetQuery(db, "
SELECT employeeid, lastname, firstname, address, homephone
                        FROM Employees
                        ")
write.csv(employees, './tmp/employees.csv')

# Phone numbers
phones <- data.frame(c(customers$Phone, employees$HomePhone))
names(phones)[1] <- "phone"
phones <- unique(phones)
write.csv(phones, './tmp/phones.csv')

# Addresses
addresses <- data.frame(c(customers$Address, employees$Address))
names(addresses)[1] <- "address"
addresses <- unique(addresses)
write.csv(addresses, './tmp/addresses.csv')
