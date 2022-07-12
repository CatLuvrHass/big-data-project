#!/bin/bash

input="last.csv"

sed 1d $input | while IFS="," read -r -a var

do

mongo 127.0.0.1/people --eval 'db.info.insert({INDEX: "'"${var[0]}"'"
,Name: "'"${var[1]}"'"
,Age: "'"${var[2]}"'"
,Country: "'"${var[3]}"'"
,Height: "'"${var[4]}"'"
,Hair_Colour: "'"${var[5]}"'"})'

done

