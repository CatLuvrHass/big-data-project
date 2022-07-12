-- Run this before you 

Bash scripts:
- echo "nowhere,0,nowhere,0" >> hadoop_mirrored.csv
- note that the hadoop_edges.csv uses the edges dataset (the second link they provide in the assignment brief)
- cut -d"," -f2,3,4,5  hadoop_edges.csv > clean_edges.csv

 /spark/bin/spark-shell

- import the packages:
import org.apache.spark._
import org.apache.spark.rdd.RDD
import org.apache.spark.graphx._
import org.apache.spark.util.IntParam
import org.apache.spark.graphx.util.GraphGenerators

-- Creating a mapper using hadoop_mirrored.csv --
The process:
- Create a class 
- Create a function to parse into harb_map class
- Load the data into an RDD variable
- Remove the header
- Make the mapRDD
- Create another RDD using flatMap 
- Then create the mapper

case class harb_map(HarbourName:String, HarbourNo:Long, Route: String, RouteNo:Long)
def parsingHarbMap(str: String): harb_map = {val line = str.split(","); harb_map(line(0), line(1).toLong, line(2), line(3).toLong)}
var textMapRDD = sc.textFile("./hadoop_mirrored.csv")
val header = textMapRDD.first()
textMapRDD = textMapRDD.filter(row => row != header)
val harbourMapRDD = textMapRDD.map(parsingHarbMap).cache()
val toMapHarbour = harbourMapRDD.flatMap(har => Seq((har.HarbourName, har.HarbourNo))).distinct
val harbourMap = toMapHarbour.map{ case (a, b) => (a -> b) }.collect.toMap

-- Creating the vertices using clean_edges.csv -- 
The process:
- Create a class
- Create a function to parse into the harbour class
- Load the data into an RDD variable
- Remove the header
- Make the harbourRDD
- Create another RDD using map 
- Create harbour 

case class Harbour(HarbourName:String, Route: String)
def parsingHarbour(str: String): Harbour = {val line = str.split(","); Harbour(line(1), line(2))}
var textRDD = sc.textFile("./clean_edges.csv")
val harbourHeader = textRDD.first()
textRDD = textRDD.filter(row => row != harbourHeader)
val harbourRDD = textRDD.map(parsingHarbour).cache()
val harbour = harbourRDD.flatMap(h => Seq((harbourMap(h.HarbourName), h.HarbourName))).distinct

-- Creating the edges using clean_edges.csv -- 
- Create a class
- Create a function to parse into the route class
- Load the data into an RDD variable
- Remove the header
- Make the routeTextRDD
- Create another RDD using map 
- Create edges

case class Route(Route: String, From:String, To:String)
def parsingRoute(str: String): Route = {val line = str.split(","); Route(line(0), line(1), line(2))}
var routeTextRDD = sc.textFile("./clean_edges.csv")
val routeHeader = routeTextRDD.first()
routeTextRDD = routeTextRDD.filter(row => row != routeHeader)
val routeRDD = routeTextRDD.map(parsingRoute).cache()
val route = routeRDD.map(ro =>((harbourMap(ro.From), harbourMap(ro.To), ro.Route))).distinct
val edges = route.map { case (origin, destination, route) => Edge(origin, destination, route) }

-- Finally, create the graph --

val nowhere = "nowhere"
val graph = Graph(harbour, edges, nowhere)

Part2

graph.collectEdges(EdgeDirection.Either).take(1)

part 3

// part 3
graph.edges.filter { case ( Edge(origin, destination, route))=> route == "Porium_Thirty-one"}.foreach(println)



//part 4
// Define a reduce operation to compute the highest degree vertex
def max(a: (VertexId, Int), b: (VertexId, Int)): (VertexId, Int) = {
  if (a._2 > b._2) a else b
}
val maxDegrees: (VertexId, Int)   = graph.degrees.reduce(max) 



//answer no5:
graph.collectNeighbors(EdgeDirection.Either).take(1)
val neigbours = graph.collectNeighborIds(EdgeDirection.In).sortBy(_._1, ascending=false) """ this can be written in different way.  EdgeDirection.Out will not have 0 which is nowhere but if we do either. nowhere is the most popular - its actually because many come from "nowehre" of 0."""


val lenMap = neigbours.map { case (id, neighbours) => (id, neighbours.distinct.length) } 

lenMap.sortBy(_._2, ascending=false).take(3)


