#!/bin/bash

sudo mysql << EOF
USE mysql

create database IF NOT EXISTS people;

USE people;
CREATE TABLE IF NOT EXISTS general_info(indx SMALLINT NOT NULL,name VARCHAR(50) NOT NULL
,age SMALLINT NOT NULL
,country VARCHAR(50) NOT NULL
,height INT(10) NOT NULL
,hair_colour VARCHAR(50) NOT NULL)
EOF

# insert all values
input="last.csv"
sed 1d $input | while IFS=, read -r indx name age country height hair_color
do

sudo mysql -h localhost -D "people" -e "insert into general_info values('$indx', '$name', '$age', '$country', '$height', '$hair_color')"
done
