## Summary

This material was the basis for a presentation by Zach Beaver and me entitled "Beyond SQL: Intro to Graph Databases" at Predictive Analytics World for Government on October 13, 2015.

## Files

* northwind.db: Northwind SQLite database obtained from https://github.com/stoianivanov/NoObstacles
* convert_from_sql.R: this uses the Northwind database to create a set of CSVs to be used in the creation of a Neo4j graph database. The files represent orders, customers, employees, phone numbers, and addresses.
* load_db.cql: Cypher Query Language file that uses the CSV files generated in R to create nodes and edges in Neo4j.
* load_script.txt: this is an example of how to call Neo4j from the command line and execute the CQL file.
* Intro to Graph Databases.pptx: the slides that Zach and I presented. During the presentation I demonstrated the graph database and ran live Cypher queries in the Neo4j web console.