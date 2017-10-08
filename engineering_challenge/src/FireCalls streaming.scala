// Databricks notebook source
// MAGIC %md ## **Coya Example: Streaming `FireCalls` **

// COMMAND ----------

// MAGIC %md #### Simulating the streaming process - sending fire calls types  

// COMMAND ----------

// Simulating the streaming process
import org.apache.spark._
import org.apache.spark.storage._
import org.apache.spark.streaming._
import scala.util.Random
import org.apache.spark.streaming.receiver._

val stopActiveContext = true	 
val batchIntervalSeconds = 1 
val eventsPerSecond = 10   

// Following code is based on databricks streaming notebook
class DummySource(ratePerSec: Int) extends Receiver[String](StorageLevel.MEMORY_AND_DISK_2) {

  def onStart() {
    // Start the thread that receives data over a connection
    new Thread("Dummy Source") {
      override def run() { receive() }
    }.start()
  }

  def onStop() {
   // There is nothing much to do as the thread calling receive()
   // is designed to stop by itself isStopped() returns false
  }

  /** Create a socket connection and receive data until receiver is stopped */
  private def receive() {
    // val sparkDF = sqlContext.read.format("parquet").load("/coya_bi_challenge/flight_df")
    val calls = Set("ENTERTAINMENT_COMMISSION",
                    "ENCAMPMENTS", 
                    "DAMAGED_PROPERTY",
                    "DPW_VOLUNTEER_PROGRAMS",
                    "CONSTRUCTION_ZONE_PERMITS",
                    "COLOR_CURB",
                    "CATCH_BASIN_MAINTENANCE",
                    "BLOCKED_STREET_OR_SIDEWALK",
                    "ABANDONED_VEHICLE",
                    "311_EXTERNAL_REQUEST"
        )
    val rnd = new Random
    while(!isStopped()) {      
      store(calls.toVector(rnd.nextInt(calls.size)))
      Thread.sleep((1000.toDouble / ratePerSec).toInt)
    }
  }
}

// COMMAND ----------

var newContextCreated = false      // Flag to detect whether new context was created or not

// Function to create a new StreamingContext and set it up
def creatingFunc(): StreamingContext = {
    
  // Create a StreamingContext
  val ssc = new StreamingContext(sc, Seconds(batchIntervalSeconds))
  
  // Create a stream that generates 1000 lines per second
  val stream = ssc.receiverStream(new DummySource(eventsPerSecond))  
  
  // Split the lines into words, and then do word count
  val wordStream = stream.flatMap { _.split(" ")  }
  val wordCountStream = wordStream.map(word => (word, 1)).reduceByKey(_ + _)

  // Create temp table at every batch interval
  wordCountStream.foreachRDD { rdd => 
    rdd.toDF("word", "count").createOrReplaceTempView("fire_calls_count")    
  }
  
  stream.foreachRDD { rdd =>
    System.out.println("Receiving stream-data... total: " + rdd.count())
  }
  
  ssc.remember(Minutes(2))  // To make sure data is not deleted by the time we query it interactively
  
  println("Creating function called to create new StreamingContext")
  newContextCreated = true  
  ssc
}

// COMMAND ----------

// MAGIC %md ### Start Streaming

// COMMAND ----------

// Stop any existing StreamingContext 
if (stopActiveContext) {	
  StreamingContext.getActive.foreach { _.stop(stopSparkContext = false) }
} 

// Get or create a streaming context
val ssc = StreamingContext.getActiveOrCreate(creatingFunc)
if (newContextCreated) {
  println("New context created") 
} else {
  println("Existing context running or recovered from checkpoint")
}

// Start the streaming context in the background.
ssc.start()

// This is to ensure that we wait for some time before the background streaming job starts. This will put this cell on hold for 5 times the batchIntervalSeconds.
ssc.awaitTerminationOrTimeout(batchIntervalSeconds * 5 * 1000)


// COMMAND ----------

// MAGIC %md ## Visualize incoming call-types 
// MAGIC Shows how many calls of certain type were recorded last second

// COMMAND ----------

// Keep reruning this cell every few seconds to see which calls types were received last second
display(spark.sql("select * from fire_calls_count"))

// COMMAND ----------

StreamingContext.getActive.foreach { _.stop(stopSparkContext = false) }
