In order to run these java files you need to get docker-hadoop

## steps:
download this link
``git clone https://github.com/big-data-europe/docker-hadoop.git``
then go into repo
``cd docker-hadoop``
and run the following
``git checkout tags/3.2.1``
``docker compose up -d``

to check you have the container run
``docker ps``

### to set up environment in the docker

``docker exec -it namenode bash`` brings you in
then ``apt update``
and install nano or vim ``apt install wget ca-certificates nano``

### To set the scripts:
download the csv
wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1SrurEuPrw04S6afIPXl1WKuL73JRuULT' -O hadoop.csv
make an input directory

``hdfs dfs -mkdir /input``
move the file to input 
``hdfs dfs -copyFromLocal ./files/hadoop.csv /input``

### To execute the scripts:
``export HADOOP_CLASSPATH=/usr/lib/jvm/java-1.8.0-openjdk-amd64/lib/tools.jar``

compile file
``hadoop com.sun.tools.javac.Main ScriptName.java``

make a jar file
``jar cf wc.jar ScriptName*.class``

then run it 
``hadoop jar wc.jar ScriptName /input /output2``

make sure to change output number like output2 output3 and so on.

