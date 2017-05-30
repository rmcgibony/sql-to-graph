MATCH (n)
OPTIONAL MATCH (n)-[r]-()
DELETE n,r;

LOAD CSV WITH HEADERS FROM 'file:///C:/Users/rmcgibony/Box Sync/Ryan McGibony/Graph Databases Talk/tmp/customers.csv' as line
CREATE (c:Customer {id: line.CustomerID})
SET c.company_name = line.CompanyName,
	c.contact_name = line.ContactName;

LOAD CSV WITH HEADERS FROM 'file:///C:/Users/rmcgibony/Box Sync/Ryan McGibony/Graph Databases Talk/tmp/employees.csv' as line
CREATE (e:Employee {id: line.EmployeeID})
SET e.first_name = line.FirstName,
	e.last_name = line.LastName;
	
LOAD CSV WITH HEADERS FROM 'file:///C:/Users/rmcgibony/Box Sync/Ryan McGibony/Graph Databases Talk/tmp/phones.csv' as line
CREATE (p:Phone {number: line.phone});

LOAD CSV WITH HEADERS FROM 'file:///C:/Users/rmcgibony/Box Sync/Ryan McGibony/Graph Databases Talk/tmp/addresses.csv' as line
CREATE (a:Address {address: line.address});

LOAD CSV WITH HEADERS FROM 'file:///C:/Users/rmcgibony/Box Sync/Ryan McGibony/Graph Databases Talk/tmp/orders.csv' as line
CREATE (r:Return {order_id: line.OrderID})
SET r.amount = TOINT(line.total);

// Relationships
LOAD CSV WITH HEADERS FROM 'file:///C:/Users/rmcgibony/Box Sync/Ryan McGibony/Graph Databases Talk/tmp/customers.csv' as line
MATCH (c:Customer {id: line.CustomerID})
MATCH (p:Phone {number: line.Phone})
CREATE (c)-[:HAS_PHONE]->(p);

LOAD CSV WITH HEADERS FROM 'file:///C:/Users/rmcgibony/Box Sync/Ryan McGibony/Graph Databases Talk/tmp/customers.csv' as line
MATCH (c:Customer {id: line.CustomerID})
MATCH (a:Address {address: line.Address})
CREATE (c)-[:HAS_ADDRESS]->(a);

LOAD CSV WITH HEADERS FROM 'file:///C:/Users/rmcgibony/Box Sync/Ryan McGibony/Graph Databases Talk/tmp/employees.csv' as line
MATCH (e:Employee {id: line.EmployeeID})
MATCH (p:Phone {number: line.HomePhone})
CREATE (e)-[:HAS_PHONE]->(p);

LOAD CSV WITH HEADERS FROM 'file:///C:/Users/rmcgibony/Box Sync/Ryan McGibony/Graph Databases Talk/tmp/employees.csv' as line
MATCH (e:Employee {id: line.EmployeeID})
MATCH (a:Address {address: line.Address})
CREATE (c)-[:HAS_ADDRESS]->(a);

LOAD CSV WITH HEADERS FROM 'file:///C:/Users/rmcgibony/Box Sync/Ryan McGibony/Graph Databases Talk/tmp/orders.csv' as line
MATCH (e:Employee {id: line.EmployeeID})
MATCH (r:Return {order_id: line.OrderID})
CREATE (e)-[:PROCESSED]->(r);

LOAD CSV WITH HEADERS FROM 'file:///C:/Users/rmcgibony/Box Sync/Ryan McGibony/Graph Databases Talk/tmp/orders.csv' as line
MATCH (c:Customer {id: line.CustomerID})
MATCH (r:Return {order_id: line.OrderID})
CREATE (c)-[rel:REQUESTED]->(r)
SET rel.date = line.ShippedDate;


// Insert suspicious relationships
CREATE (e:Employee {id:10, first_name:'Roger', last_name:'Thompson'});

MATCH (a:Address {address:'8 Johnstown Road'}), (e:Employee {id:10})
CREATE (e)-[r:HAS_ADDRESS]->(a);

MATCH (e:Employee {id:10}), (p:Phone {number:'(503) 555-6874'})
CREATE (e)-[r:HAS_PHONE]->(p);

CREATE (r:Return {order_id:11078, return_date:'1996-08-10', amount:2100});

MATCH (c:Customer {id:'HUNGO'}), (r:Return {order_id:11078})
CREATE (c)-[:REQUESTED]->(r);

MATCH (e:Employee {id:10}), (r:Return {order_id:11078})
CREATE (e)-[:PROCESSED]->(r);

CREATE (r:Return {order_id:11079, return_date:'1996-08-12', amount:1350});

MATCH (c:Customer {id:'BSBEV'}), (r:Return {order_id:11079})
CREATE (c)-[:REQUESTED]->(r);

MATCH (e:Employee {id:10}), (r:Return {order_id:11079})
CREATE (e)-[:PROCESSED]->(r);