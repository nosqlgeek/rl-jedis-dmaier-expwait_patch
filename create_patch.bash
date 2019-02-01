#!/bin/bash

## Set current working directory
WD=$PWD

## Clean
rm *.patch
rm -Rf jedis
rm -Rf patches

## Make sure we have a working Maven build environment
source /Users/david/opt/apache-maven-3.5.4/env.bash

## Create target folder
mkdir patches

## Get the source code 
git clone https://github.com/nosqlgeek/jedis.git

## Create patch file
cd jedis
git checkout 2.9
git checkout 2.9-dmaier-expwait
git format-patch 2.9
cp 0001-Added-wait-strategies-to-Jedis-Modified-SentinelPool.patch $WD/patches/2.9-dmaier-expwait.patch

## Build the current branch
mvn install -DskipTests

## Copy the build artifacts
cp target/jedis-2.9.1-SNAPSHOT.jar $WD/patches

## Run manual test
export CLASSP=$WD/jedis/target/classes:$WD/jedis/target/test-classes:$WD/deps/slf4j-api-1.7.5.jar:$WD/deps/commons-pool2-2.4.3.jar:$WD/deps/slf4j-jdk14-1.7.25.jar

java -cp $CLASSP redis.clients.jedis.tests.wait.SentinelFailoverTest -Djava.util.logging.config.file=$WD/res/logging.properties

## Clean
cd $WD
rm -Rf jedis
